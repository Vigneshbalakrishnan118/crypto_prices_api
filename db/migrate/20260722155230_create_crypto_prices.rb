class CreateCryptoPrices < ActiveRecord::Migration[8.0]
  def change
    create_table :crypto_prices do |t|
      t.string :symbol, null: false
      t.decimal :price, precision: 20, scale: 8, null: false
      t.string :currency, null: false, default: "usd"
      t.datetime :fetched_at, null: false

      t.timestamps
    end

    add_index :crypto_prices, :symbol, unique: true
  end
end
