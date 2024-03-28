require 'rails_helper'
require 'webmock/rspec'
require_relative '../../app/services/geocode_api'


RSpec.describe GeocodeApi, type: :service do
  describe '.geocode' do
    let(:address) { '1600 Amphitheatre Parkway, Mountain View, CA' }
    let(:access_token) { 'fake_access_token' }
    let(:base_url) { "https://api.mapbox.com/geocoding/v5/mapbox.places/" }
    let(:query_params) { URI.encode_www_form({ address: address }) }
    let(:url) { "#{base_url}#{query_params}.json?access_token=#{access_token}" }

    before do
      allow(ENV).to receive(:fetch).with('MAPBOX_TOKEN').and_return(access_token)
    end

    context 'when the API request is successful' do
      let(:response_body) do
        {
          "type": "FeatureCollection",
          "features": [
            {
              "geometry": {
                "coordinates": [-122.084, 37.422]
              }
            }
          ]
        }.to_json
      end

      before do
        stub_request(:get, url)
          .to_return(
            status: 200,
            body: response_body,
            headers: { 'Content-Type': 'application/json' }
          )
      end

      it 'returns the coordinates' do
        expect(GeocodeApi.geocode(address)).to eq([-122.084, 37.422])
      end
    end

    context 'when the API request fails' do
      before do
        stub_request(:get, url)
          .to_return(status: 500)
      end

      it 'returns nil' do
        expect(GeocodeApi.geocode(address)).to be_nil
      end
    end


    context 'when an exception occurs during the API request' do
      it 'returns nil and logs an error message' do
        allow(Net::HTTP).to receive(:get_response).and_raise(StandardError.new('Mocked API error'))
        expect { GeocodeApi.geocode(address) }.to output(/Error fetching geocoded data/).to_stdout
        expect(GeocodeApi.geocode(address)).to be_nil
      end
    end
  end
end
