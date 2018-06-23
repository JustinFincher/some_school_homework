class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices do |t|
      t.integer :flight_id
      t.float :price
      t.integer :seat_level

      t.timestamps
    end
  end
end
