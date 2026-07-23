# frozen_string_literal: true

class PriceLookupService
  def initialize(symbol)
    @symbol = symbol
  end

  def call
    cached_price || database_price
  end

  private

  attr_reader :symbol

  def cached_price
    CryptoPriceCache.read(symbol)
  end

  def database_price
    record = CryptoPrice.find_by(symbol: symbol)

    CryptoPriceCache.write(record) if record.present?

    record
  end
end
