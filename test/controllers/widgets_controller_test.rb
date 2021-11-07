require 'test_helper'

class WidgetsControllerTest < ActionDispatch::IntegrationTest
  test "converts dollars to cents when creating widgets" do
    manufacturer = FactoryBot.create(:manufacturer)
    FactoryBot.create(:widget_status, name: "Fresh")
    post widgets_url, params: {
      widget: {
        name: "New widget",
        price_cents: "123.45",
        manufacturer_id: manufacturer.id
      }
    }
    widget = Widget.last
    refute_nil widget
    assert_redirected_to widget_path(widget)
    assert_equal 12345, widget.price_cents
  end
end
