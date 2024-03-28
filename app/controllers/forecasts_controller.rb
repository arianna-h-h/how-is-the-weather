class ForecastsController < ApplicationController
  def show
    forecast_service = ForecastService.new(params[:address])
    @forecast_obj = forecast_service.fetch_forecast
    @forecast = @forecast_obj[:forecast_data]
    @cached = @forecast_obj[:from_cache]
  rescue ForecastFetchError => e
    puts "An error occurred: #{e.message}"
    render plain: "An error occurred while fetching the forecast.", status: :not_found
  end
end