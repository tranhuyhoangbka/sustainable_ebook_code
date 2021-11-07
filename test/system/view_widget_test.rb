require "test_helper"
require "support/with_clues"

class ViewWidgetTest < ActionDispatch::SystemTestCase
  include TestSupport::WithClues
  driven_by :rack_test

  test "we can see a list of widgets and choose one to view" do
    FactoryBot.create(:widget, name: "Flux Capacitor")
    stembolt = FactoryBot.create(:widget, name: "Stembolt")
    stembolt.update! id: 1234
    visit widgets_path
    widget_name = "Stembolt"
    widget_name_regexp = /#{widget_name}/
    with_clues{assert_selector "ul li a", text: /Flux Capacitor/i}
    assert_selector "ul li a", text: widget_name_regexp

    find("ul li a", text: widget_name_regexp).click

    formatted_widget_id_regexp = /12\.34/
    assert_selector "[data-testid='widget-name']", text: widget_name_regexp
    assert_selector "h2", text: formatted_widget_id_regexp
  end
end
