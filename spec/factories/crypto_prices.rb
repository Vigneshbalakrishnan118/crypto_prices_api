FactoryBot.define do
  factory :crypto_price do
    symbol { "bitcoin" }
    price { 100_000 }
    currency { "usd" }
    fetched_at { Time.current }
  end
end
