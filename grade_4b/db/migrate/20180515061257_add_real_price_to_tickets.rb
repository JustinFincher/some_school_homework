class AddRealPriceToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :real_price, :float
  end
end
