require "rails_helper"

RSpec.describe "Prices API" do
  let!(:price) do
    create(:crypto_price)
  end

  it "returns price" do
    get "/prices/bitcoin"

    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)

    expect(json["symbol"]).to eq("bitcoin")
  end

  it "returns 404" do
    get "/prices/abc"

    expect(response).to have_http_status(:not_found)
  end
end
