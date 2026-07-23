# frozen_string_literal: true

class FetchCryptoPricesJob < ApplicationJob
  queue_as :default

  def perform
    SUPPORTED_SYMBOLS.each do |symbol|
      fetch(symbol)
    end
  end

  private

  def fetch(symbol)
    CryptoPriceFetcher.new.call(symbol)

    Rails.logger.info("Fetched latest price for #{symbol}")
  rescue StandardError => e
    Rails.logger.error(
      "Unable to fetch #{symbol}: #{e.class} #{e.message}"
    )
  end
end
