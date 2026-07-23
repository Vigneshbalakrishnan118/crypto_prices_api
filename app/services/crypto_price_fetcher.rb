# frozen_string_literal: true

class CryptoPriceFetcher
  def initialize(client: CoinGeckoClient.new)
    @client = client
  end

  def call(symbol)
    data = client.fetch_price(symbol)

    record = CryptoPrice.find_or_initialize_by(symbol: symbol)

    record.assign_attributes(
      price: data[:price],
      currency: data[:currency],
      fetched_at: data[:fetched_at]
    )

    record.save!

    CryptoPriceCache.write(record)

    record
  end

  private

  attr_reader :client
end
