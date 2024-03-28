require 'rails_helper'

RSpec.describe "Forecasts", type: :request do
  describe "GET #show" do
    context "with valid address" do
      let(:address) { '1600 Amphitheatre Parkway, Mountain View, CA'}

      before do
        allow(GeocodeApi).to receive(:geocode).with(address).and_return([40.7128, -74.0060])
        allow(WeatherApi).to receive(:fetch_forecast).and_return({ current_temp: 55.0, temp_unit: "°F", low: 50.0, high: 60.0 })
        get "/forecasts/show", params: { address: address }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns the forecast data" do
        expect(assigns(:forecast)).to eq({ current_temp: 55.0, temp_unit: "°F", low: 50.0, high: 60.0 })
      end

      it "assigns cached flag" do
        expect(assigns(:cached)).to be_falsey
      end
    end

    context "with invalid address" do
      let(:address) { "Invalid Address" }

      before do
        allow(GeocodeApi).to receive(:geocode).with(address).and_return(nil)
        get "/forecasts/show", params: { address: address }
      end

      it "returns a not found response" do
        expect(response).to have_http_status(:not_found)
      end

      it "does not assign forecast data" do
        expect(assigns(:forecast)).to be_nil
      end

      it "does not assign cached flag" do
        expect(assigns(:cached)).to be_falsey
      end
    end
  end
end
