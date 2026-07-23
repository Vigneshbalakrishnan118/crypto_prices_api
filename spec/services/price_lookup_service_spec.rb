require "rails_helper"

RSpec.describe PriceLookupService do
  let!(:price) do
    create(:crypto_price)
  end

  subject(:service) do
    described_class.new("bitcoin")
  end

  it "returns cached value" do
    CryptoPriceCache.write(price)

    expect(service.call).to eq(price)
  end

  it "returns db value if cache misses" do
    Rails.cache.clear

    expect(service.call).to eq(price)
  end
end
