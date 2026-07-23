# frozen_string_literal: true

class CryptoPrice < ApplicationRecord
  validates :symbol, presence: true, uniqueness: true
  validates :price, presence: true
  validates :currency, presence: true
  validates :fetched_at, presence: true
end
