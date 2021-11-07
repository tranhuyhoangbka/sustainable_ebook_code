class WidgetsController < ApplicationController
  before_action :set_widget, only: %i[ show edit update destroy ]

  # GET /widgets or /widgets.json
  def index
    @widgets = Widget.all
  end

  # GET /widgets/1 or /widgets/1.json
  def show
  end

  # GET /widgets/new
  def new
    @widget = Widget.new
    @manufacturers = Manufacturer.all
  end

  # GET /widgets/1/edit
  def edit
  end

  # POST /widgets or /widgets.json
  def create
    result = WidgetCreator.new.create_widget(Widget.new(widget_params))
    if result.created?
      redirect_to widget_path(result.widget)
    else
      @widget = result.widget
      @manufacturers = Manufacturer.all
      render :new
    end
  end

  # PATCH/PUT /widgets/1 or /widgets/1.json
  def update
    respond_to do |format|
      if @widget.update(widget_params)
        format.html { redirect_to @widget, notice: "Widget was successfully updated." }
        format.json { render :show, status: :ok, location: @widget }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /widgets/1 or /widgets/1.json
  def destroy
    @widget.destroy
    respond_to do |format|
      format.html { redirect_to widgets_url, notice: "Widget was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_widget
      @widget = Widget.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def widget_params
      if params[:widget][:price_cents].present?
        params[:widget][:price_cents] = (BigDecimal(params[:widget][:price_cents]) * 100).to_i
      end
      params.require(:widget).permit(:name, :price_cents, :manufacturer_id)
    end
end
