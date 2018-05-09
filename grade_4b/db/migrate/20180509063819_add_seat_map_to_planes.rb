class AddSeatMapToPlanes < ActiveRecord::Migration[5.1]
  def change
    add_column :planes, :seat_map, :string
  end
end
