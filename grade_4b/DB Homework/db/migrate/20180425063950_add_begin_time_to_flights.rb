class AddBeginTimeToFlights < ActiveRecord::Migration[5.1]
  def change
    add_column :flights, :begintime, :time
  end
end
