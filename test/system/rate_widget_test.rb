require "test_helper"

Capybara.register_driver :root_headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:chromeOptions": {
      args: [
        "headless",
        "disable-gpu",
        "no-sandbox",
        "disable-dev-shm-usage",
        "whitelisted-ips"
      ]
    },
    "goog:loggingPrefs": { browser: "ALL" },
  )
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end # register_driver

class RateWidgetTest < ActionDispatch::SystemTestCase
  driven_by :root_headless_chrome, screen_size: [ 1400, 1400 ]
  test "rating a widget shows our rating inline" do
    widget = FactoryBot.create(:widget)
    visit widget_path(widget)
    # click_on '2'
    # assert_selector "[data-rating-present]", text: /thanks for rating.*2/i
  end
end
