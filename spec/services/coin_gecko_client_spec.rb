require "rails_helper"

RSpec.describe CoinGeckoClient do
  subject(:client) { described_class.new }

  before do
    stub_request(:get, /simple\/price/)
      .to_return(
        status: 200,
        body: {
          bitcoin: {
            usd: 12345
          }
        }.to_json,
        headers: {
          "Content-Type" => "application/json"
        }
      )
  end

  it "returns crypto price" do
    result = client.fetch_price("bitcoin")

    expect(result[:symbol]).to eq("bitcoin")
    expect(result[:price]).to eq(12345)
  end
end
