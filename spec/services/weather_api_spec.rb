require 'spec_helper'
require 'webmock/rspec'
require_relative '../../app/services/weather_api'

RSpec.describe WeatherApi, type: :service do
  describe '.fetch_forecast' do
    let(:coordinates) { [40.7128, -74.0060] }

    context 'when the API request is successful' do
      before do
        stub_request(:get, /api.open-meteo.com/)
          .to_return(
            status: 200,
            body: {
              "current": { "temperature_2m": 55.0 },
              "current_units": { "temperature_2m": "°F" },
              "daily": { "temperature_2m_max": [60.0], "temperature_2m_min": [50.0] }
            }.to_json,
            headers: { 'Content-Type': 'application/json' }
          )
      end

      it 'returns forecast data' do
        forecast_data = WeatherApi.fetch_forecast(coordinates)
        expect(forecast_data).to include(current_temp: 55.0, temp_unit: "°F", low: 50.0, high: 60.0)
      end
    end

    context 'when the API request fails' do
      before do
        stub_request(:get, /api.open-meteo.com/)
          .to_return(status: 500)
      end

      it 'returns nil' do
        forecast_data = WeatherApi.fetch_forecast(coordinates)
        expect(forecast_data).to be_nil
      end
    end

    context 'when an exception occurs during the API request' do
      it 'returns nil and logs an error message' do
        allow(Net::HTTP).to receive(:get_response).and_raise(StandardError.new('Mocked API error'))
        expect { WeatherApi.fetch_forecast(coordinates) }.to output(/Error fetching forecast data/).to_stdout
        expect(WeatherApi.fetch_forecast(coordinates)).to be_nil
      end
    end
  end
end