class RemovePriceFromTickets < ActiveRecord::Migration[5.1]
  def change
    remove_column :tickets, :price, :float
  end
end
