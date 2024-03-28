require 'rails_helper'

RSpec.describe ForecastService do
  describe '#fetch_forecast' do
    let(:address) { '1600 Amphitheatre Parkway, Mountain View, CA' }

    context 'when forecast is cached' do
      let(:cached_data) { { address: address, forecast_data: 'cached forecast data', from_cache: true } }

      before do
        allow(Rails.cache).to receive(:read).and_return(cached_data)
      end

      it 'returns cached forecast data' do
        forecast_service = described_class.new(address)
        result = forecast_service.fetch_forecast
        expect(result).to eq(cached_data)
      end
    end

    context 'when forecast is not cached' do
      let(:coordinates) { [40.7128, -74.0060] }
      let(:forecast_data) { 'forecast data' }

      before do
        allow(GeocodeApi).to receive(:geocode).with(address).and_return(coordinates)
        allow(WeatherApi).to receive(:fetch_forecast).with(coordinates).and_return(forecast_data)
      end

      it 'fetches and caches the forecast data' do
        cache_data = { address: address, forecast_data: forecast_data }
        expect(Rails.cache).to receive(:write).with(address.parameterize, cache_data, expires_in: 30.minutes)
        forecast_service = described_class.new(address)
        result = forecast_service.fetch_forecast
        expect(result).to eq({ forecast_data: forecast_data })
      end
    end
  end
end
