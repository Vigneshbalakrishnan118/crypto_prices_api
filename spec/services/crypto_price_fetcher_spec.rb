require "rails_helper"

RSpec.describe CryptoPriceFetcher do
  let(:client) { instance_double(CoinGeckoClient) }

  subject(:service) do
    described_class.new(client:)
  end

  before do
    allow(client)
      .to receive(:fetch_price)
      .and_return(
        {
          symbol: "bitcoin",
          price: 1000,
          currency: "usd",
          fetched_at: Time.current
        }
      )
  end

  it "creates price" do
    expect {
      service.call("bitcoin")
    }.to change(CryptoPrice, :count).by(1)
  end

  it "updates existing price" do
    create(:crypto_price, symbol: "bitcoin", price: 500)

    service.call("bitcoin")

    expect(
      CryptoPrice.find_by(symbol: "bitcoin").price
    ).to eq(1000)
  end
end
