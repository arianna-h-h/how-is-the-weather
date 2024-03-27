class ForecastService
  def initialize(address)
    @address = address
  end

  def fetch_forecast
    cached_forecast || fetch_and_cache_forecast
  end

  private

  def cached_forecast
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) if cache_key
  end

  def fetch_and_cache_forecast
    coordinates = GeocodeAPI.geocode(@address)
    return nil unless coordinates

    forecast_data = WeatherAPI.fetch_forecast(coordinates[:latitude], coordinates[:longitude])
    Rails.cache.write(cache_key, forecast_data, expires_in: 30.minutes) if cache_key
    forecast_data
  end

  def cache_key
    @address.parameterize if @address
  end
end