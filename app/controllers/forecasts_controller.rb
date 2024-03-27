class ForecastsController < ApplicationController
  def show
    forecast_service = ForecastService.new(params[:address]).fetch_forecast
    @forecast = forecast_service.fetch_forecast
    @cached = forecast_service.cached_forecast.present?
  end
end
