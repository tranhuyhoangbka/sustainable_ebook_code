class Api::V1::WidgetDatasheetsController < ApiController
  skip_before_action :require_json
  before_action :require_json_or_pdf

  def show
    respond_to do |format|
      format.json do
      end

      format.pdf do
      end
    end
  end

  private

  def require_json_or_pdf
    unless request.format.json? || request.format.pdf?
      head 406
    end
  end
end
