COIN_GECKO_API_KEY = ENV.fetch(
  "COINGECKO_API_KEY",
  "CG-u5ZvsvVpyous4vka8YZcQcAr"
)

SUPPORTED_SYMBOLS = %w[
  bitcoin
  ethereum
  solana
  dogecoin
].freeze
