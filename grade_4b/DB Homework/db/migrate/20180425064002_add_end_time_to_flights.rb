class AddEndTimeToFlights < ActiveRecord::Migration[5.1]
  def change
    add_column :flights, :endtime, :time
  end
end
