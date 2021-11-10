require 'test_helper'

class Api::AuthenticationTest < ActionDispatch::IntegrationTest
  test 'without api key, get a 401' do
    widget = FactoryBot.create(:widget)
    get api_v1_widget_path(widget), headers: {"Accept" => "application/json"}
    assert_response 401
  end

  test 'with non-exist api key, get a 401' do
    authorization = ActionController::HttpAuthentication::Token.encode_credentials('not real')
    widget = FactoryBot.create(:widget)
    get api_v1_widget_path(widget), headers: {"Accept" => "application/json", "Authorization" => authorization}
    assert_response 401
  end

  test 'with deactived api key, get 401' do
    api_key = FactoryBot.create(:api_key, deactived_at: 1.days.ago)
    authorization = ActionController::HttpAuthentication::Token.encode_credentials(api_key.key)
    widget = FactoryBot.create(:widget)
    get api_v1_widget_path(widget), headers: {"Accept" => "application/json", "Authorization" => authorization}
    assert_response 401
  end
end
