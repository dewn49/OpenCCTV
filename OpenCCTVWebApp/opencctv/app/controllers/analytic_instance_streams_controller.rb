class AnalyticInstanceStreamsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_action :set_analytic_instance_stream, only: [:show, :edit, :update, :destroy]
  before_action :set_analytic_instance, only: [:index, :new, :create, :edit, :show, :update, :destroy]
  respond_to :html

  def index
    redirect_to analytic_instance_path(@analytic_instance)
  end

  def show
    respond_with(@analytic_instance_stream)
  end

  def new
    flash[:alert] = "Analytic instance may not work properly if the input streams are not properly configured"
    @analytic_instance_stream = AnalyticInstanceStream.new
    @analytic_instance_stream.analytic_instance = @analytic_instance
    respond_with(@analytic_instance_stream)
  end

  def edit
    flash[:alert] = "Analytic instance may not work properly if the input streams are not properly configured"
  end

  def create
    @analytic_instance_stream = AnalyticInstanceStream.new
    @analytic_instance_stream.analytic_instance = @analytic_instance

    if params[:analytic_instance_stream][:analytic_input_stream_id].present?
      @analytic_instance_stream.analytic_input_stream = AnalyticInputStream.find(params[:analytic_instance_stream][:analytic_input_stream_id])
    end

    if params[:analytic_instance_stream][:stream_id].present?
      @analytic_instance_stream.stream = Stream.find(params[:analytic_instance_stream][:stream_id])
    end

    @analytic_instance_stream.save

    if @analytic_instance_stream.errors.any?
      respond_with(@analytic_instance_stream)
    else
      redirect_to analytic_instance_path(@analytic_instance)
    end
  end

  def update
    @analytic_instance_stream.update(analytic_input_stream_id: params[:analytic_instance_stream][:analytic_input_stream_id], stream_id: params[:analytic_instance_stream][:stream_id]   )

    if @analytic_instance_stream.errors.any?
      respond_with(@analytic_instance_stream)
    else
      redirect_to analytic_instance_analytic_instance_stream_path(@analytic_instance, @analytic_instance_stream)
    end
  end

  def destroy
    @analytic_instance_stream.destroy
    redirect_to analytic_instance_path(@analytic_instance)
  end

  private
    def set_analytic_instance_stream
      @analytic_instance_stream = AnalyticInstanceStream.find(params[:id])
    end

    def set_analytic_instance
      @analytic_instance = AnalyticInstance.find(params[:analytic_instance_id])
    end

    def analytic_instance_stream_params
      params.require(:analytic_instance_stream).permit(:analytic_instance_id, :analytic_input_stream_id, :stream_id)
    end
end
