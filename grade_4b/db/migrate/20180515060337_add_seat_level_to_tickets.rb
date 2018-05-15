class AddSeatLevelToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :seat_level, :integer
  end
end
