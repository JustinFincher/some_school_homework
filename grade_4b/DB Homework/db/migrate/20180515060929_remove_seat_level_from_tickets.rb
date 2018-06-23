class RemoveSeatLevelFromTickets < ActiveRecord::Migration[5.1]
  def change
    remove_column :tickets, :seat_level, :integer
  end
end
