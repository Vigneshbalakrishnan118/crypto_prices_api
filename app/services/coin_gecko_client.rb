# frozen_string_literal: true

class CoinGeckoClient
  BASE_URL = "https://api.coingecko.com".freeze

  def initialize(connection: nil)
    @connection = connection || default_connection
  end

  def fetch_price(symbol)
    response = connection.get("api/v3/simple/price") do |req|
      req.params["ids"] = symbol
      req.params["vs_currencies"] = "usd"
    end

    raise "CoinGecko request failed" unless response.success?

    json = JSON.parse(response.body)

    price = json.dig(symbol, "usd")

    raise "Price not found" if price.nil?

    {
      symbol: symbol,
      price: price,
      currency: "usd",
      fetched_at: Time.current
    }
  end

  private

  attr_reader :connection

  def default_connection
    Faraday.new(
      url: BASE_URL,
      headers: {
        "x-cg-demo-api-key" => COIN_GECKO_API_KEY,
        "Accept" => "application/json"
      }
    )
  end
end
