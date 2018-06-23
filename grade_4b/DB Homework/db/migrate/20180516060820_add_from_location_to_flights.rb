class AddFromLocationToFlights < ActiveRecord::Migration[5.1]
  def change
    add_column :flights, :from_location, :string
  end
end
