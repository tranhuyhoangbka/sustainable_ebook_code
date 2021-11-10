class ApplicationController < ActionController::Base
  before_action :set_request_id_in_thread_local

  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.request_id
  end

  def set_request_id_in_thread_local
    Thread.current.thread_variable_set("request_id", request.request_id)
  end
end
