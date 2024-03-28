require 'net/http'
require 'json'

class GeocodeApi
  def self.geocode(address)
    access_token = ENV.fetch('MAPBOX_TOKEN')
    base_url = "https://api.mapbox.com/geocoding/v5/mapbox.places/"
    query_params = URI.encode_www_form({address: address})
    url = "#{base_url}#{query_params}.json?access_token=#{access_token}"
    response = Net::HTTP.get_response(URI(url))
    if response.is_a?(Net::HTTPSuccess)
      parse_geocode_response(response.body)
    else
      puts "API request failed with status code: #{response.code}"
      nil
    end
  rescue => e
    puts "Error fetching geocoded data: #{e.message}"
  end

  def self.parse_geocode_response(response)
    parsed_data = JSON.parse(response)
    parsed_data['features'][0]['geometry']['coordinates']
  end 
end