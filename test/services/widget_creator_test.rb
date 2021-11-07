require 'test_helper'

class WidgetCreatorTest < ActiveSupport::TestCase
  setup do
    Sidekiq::Testing.inline!
    @widget_creator = WidgetCreator.new
    @manufacturer = FactoryBot.create(:manufacturer, created_at: 1.year.ago)
    FactoryBot.create(:widget_status)
    FactoryBot.create(:widget_status, name: "Fresh")
    ActionMailer::Base.deliveries = []
  end

  teardown do
    Sidekiq::Testing.fake!
  end

  test "widgets have a default status of 'Fresh'" do
    result = @widget_creator.create_widget(Widget.new(name: "Stembolt", price_cents: 1_000_00,
      manufacturer_id: @manufacturer.id))
    assert result.created?
    assert_equal Widget.last, result.widget
    assert_equal "Fresh", result.widget.widget_status.name
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "widget names must be 5 chars or greater" do
    result = @widget_creator.create_widget(Widget.new(
      name: "widg",
      price_cents: 1_000_00,
      manufacturer_id: @manufacturer.id
    ))

    refute result.created?
    assert result.widget.invalid?
    too_short_error = result.widget.errors[:name].detect{|msg| msg =~ /is too short/i}
    refute_nil too_short_error, result.widget.errors.full_messages.join(",")
  end

  test "finance is notified for widgets priced over $7,500" do
    result = @widget_creator.create_widget(Widget.new(
      name: "Stembolt",
      price_cents: 7_500_01,
      manufacturer_id: @manufacturer.id
    ))

    assert result.created?
    assert_equal 1, ActionMailer::Base.deliveries.size
    mail_message = ActionMailer::Base.deliveries.first
    assert_equal "finance@example.com", mail_message["to"].to_s
    assert_match /Stembolt/, mail_message.text_part.to_s
  end

  test "name, price, and manufacturer are required" do
    result = @widget_creator.create_widget(Widget.new)
    refute result.created?
    widget = result.widget
    assert widget.invalid?
    assert widget.errors[:name].any?{|msg| msg =~ /can't be blank/},
      widget.errors.full_messages_for(:name)

    assert widget.errors[:price_cents].any?{|msg| msg =~ /can't be blank/},
      widget.errors.full_messages_for(:price_cents)

    assert widget.errors[:manufacturer].any?{|msg| msg =~ /must exist/},
      widget.errors.full_messages_for(:manufacturer)
  end

  test "price cannot be 0" do
    result = @widget_creator.create_widget(Widget.new(
      name: "Stembolt",
      price_cents: 0,
      manufacturer_id: @manufacturer.id
    ))
    refute result.created?
    assert result.widget.errors[:price_cents].any?{|msg| msg =~ /greater than 0/i},
      result.widget.errors.full_messages_for(:price_cents)
  end

  test "price cannot be more than 10,000" do
    result = @widget_creator.create_widget(Widget.new(
      name: "Stembolt",
      price_cents: 10_000_01,
      manufacturer_id: @manufacturer.id
    ))
    refute result.created?
    assert result.widget.errors[:price_cents].any?{|msg| msg =~ /less than or equal to 1000000/i},
      result.widget.errors.full_messages_for(:price_cents)
  end

  test "legacy manufacturers cannot have a price under $100" do
    legacy_manufacturer = FactoryBot.create(:manufacturer, created_at: DateTime.new(2010,1,1) - 1.day)
    result = @widget_creator.create_widget(Widget.new(
      name: "Stembolt",
      price_cents: 99_00,
      manufacturer_id: legacy_manufacturer.id
    ))
    refute result.created?
    assert result.widget.errors[:price_cents].any?{|msg| msg =~ /< \$100.*legacy/i},
      result.widget.errors.full_messages_for(:price_cents)
  end

  test "email adming staff for widgets on new manufacturers" do
    new_manufacturer = FactoryBot.create(:manufacturer, name: "Cyberdine Systems",
      created_at: 59.days.ago)
    result = @widget_creator.create_widget(Widget.new(
      name: "Stembolt",
      price_cents: 99_00,
      manufacturer_id: new_manufacturer.id
    ))
    assert result.created?
    assert_equal 1, ActionMailer::Base.deliveries.size
    mail_message = ActionMailer::Base.deliveries.first
    assert_equal "admin@example.com", mail_message["to"].to_s
    assert_match /Stembolt/, mail_message.text_part.to_s
    assert_match /Cyberdine Systems/, mail_message.text_part.to_s
  end
end
