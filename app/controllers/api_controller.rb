class ApiController < ApplicationController
  # call https://username:password@api.example.com/api/widgets.json
  # http_basic_authenticate_with name: ENV['API_USERNAME'], password: ENV['API_PASSWORD']
  before_action :authenticate, :require_json

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.find_by(key: token, deactived_at: nil).present?
    end
  end

  def require_json
    if !request.format.json?
      head 406
    end
  end
end
