Rails.application.configure do
  if !Rails.env.development? || ENV["LOGRAGE_IN_DEVELOPMENT"] == "true"
    config.lograge.enabled = true
  else
    config.lograge.enabled = false
  end

  config.lograge.custom_options = lambda do |event|
    {
      request_id: event.payload[:request_id]
    }
  end
end

