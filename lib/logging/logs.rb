module Logging
  module Logs
    REQUEST_ID_KEY = "request_id"
    def log(message_or_object, message = nil)
      request_id = Thread.current.thread_variable_get(REQUEST_ID_KEY)
      message = if message.nil?
        message_or_object
      else
        object = message_or_object
        if object.respond_to?(:id)
          "(#{object.class}/#{object.id}) #{message}"
        else
          "(#{object.class}/#{object}) #{message}"
        end
      end
      Rails.logger.info("#{self.class.name} request_id: #{request_id} #{message}")
    end
  end
end
