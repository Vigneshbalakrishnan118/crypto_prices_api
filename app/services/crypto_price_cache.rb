# frozen_string_literal: true

class CryptoPriceCache
  CACHE_EXPIRY = 1.minute

  class << self
    def read(symbol)
      Rails.cache.read(cache_key(symbol))
    end

    def write(record)
      Rails.cache.write(
        cache_key(record.symbol),
        record,
        expires_in: CACHE_EXPIRY
      )
    end

    def delete(symbol)
      Rails.cache.delete(cache_key(symbol))
    end

    private

    def cache_key(symbol)
      "crypto_price:#{symbol}"
    end
  end
end
