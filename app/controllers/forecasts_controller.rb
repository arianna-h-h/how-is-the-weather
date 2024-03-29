class ForecastsController < ApplicationController
  def show
    forecast_service = ForecastService.new(params[:address])
    @forecast_results = forecast_service.fetch_forecast
    @forecast = @forecast_results[:forecast_data]
    @cached = @forecast_results[:from_cache]
  rescue ForecastFetchError => e
    puts "An error occurred: #{e.message}"
    render plain: "An error occurred while fetching the forecast.", status: :not_found
  end
end