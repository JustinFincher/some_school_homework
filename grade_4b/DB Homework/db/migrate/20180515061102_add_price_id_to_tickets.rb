class AddPriceIdToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :price_id, :integer
  end
end
