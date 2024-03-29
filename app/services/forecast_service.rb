class ForecastService

  def initialize(address)
    @address = address
  end

  def fetch_forecast
    return cached_forecast if cached_forecast
    fetch_and_cache_forecast
  end

  private

  def cached_forecast
    cached_data = Rails.cache.read(cached_address) if cached_address
    if cached_data && cached_data[:address] == @address
      cached_data[:from_cache] = true
      cached_data
    else
      nil
    end
  end

  def fetch_and_cache_forecast
    coordinates = GeocodeApi.geocode(@address)
    raise ForecastFetchError if coordinates.nil?
    forecast_data = WeatherApi.fetch_forecast(coordinates)
    raise ForecastFetchError if forecast_data.nil?
    cache_data = { address: @address, forecast_data: forecast_data }
    Rails.cache.write(cached_address, cache_data, expires_in: 30.minutes) if cached_address
    { forecast_data: forecast_data }
  end

  def cached_address
    @address.parameterize if @address
  end
end

class ForecastFetchError < StandardError
  def initialize(message = 'Error fetching forecast data')
    super
  end
end