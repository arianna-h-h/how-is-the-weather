require 'json'

class WeatherApi
  def self.fetch_forecast(coordinates)
    base_url = "https://api.open-meteo.com/v1/forecast?"
    query_params = URI.encode_www_form({ latitude: coordinates[1], longitude: coordinates[0] })
    url = "#{base_url}#{query_params}&current=temperature_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&timezone=auto"
    response = Net::HTTP.get_response(URI(url))
    response_body = response.body
    if response.is_a?(Net::HTTPSuccess)
      json_data = JSON.parse(response.body)
      current_temp = json_data["current"]["temperature_2m"]
      temp_unit = json_data["current_units"]["temperature_2m"]
      low = json_data["daily"]["temperature_2m_min"][0]
      high = json_data["daily"]["temperature_2m_max"][0]
      { current_temp: current_temp, temp_unit: temp_unit, low: low, high: high }
    else
      puts "API request failed with status code: #{response.code}"
      nil
    end
  rescue => e
    puts "Error fetching forecast data: #{e.message}"
    nil
  end
end