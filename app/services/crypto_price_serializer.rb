# frozen_string_literal: true

class CryptoPriceSerializer
  def self.call(record)
    {
      symbol: record.symbol,
      price: record.price.to_f,
      currency: record.currency,
      updated_at: record.fetched_at.iso8601,
      cached: true
    }
  end
end
