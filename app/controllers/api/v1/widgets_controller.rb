class Api::V1::WidgetsController < ApiController
  def show
    Rails.logger.info "#{request.request_id} testin..........."
    widget = Widget.find(params[:id])
    render json: {widget: widget.as_json(
      methods: [:user_facing_identifier],
      except: [:widget_status_id],
      include: [:widget_status]
    )}
  end
end
