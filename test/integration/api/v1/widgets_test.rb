require 'test_helper'

class Api::V1::WidgetsTest < ActionDispatch::IntegrationTest
  test "get a widget" do
    api_key = FactoryBot.create(:api_key)
    authorization = ActionController::HttpAuthentication::Token.encode_credentials(api_key.key)
    widget = FactoryBot.create(:widget)
    get api_v1_widget_path(widget),
      headers: {"Accept" => "application/json", "Authorization" => authorization}
    assert_reponse :success
    parsed_response = JSON.parse(response.body)
    refute_nil parsed_response["widget"]
    assert_equal widget.name, parsed_response.dig("widget", "name")
  end
end
