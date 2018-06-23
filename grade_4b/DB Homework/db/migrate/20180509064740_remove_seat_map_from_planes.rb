class RemoveSeatMapFromPlanes < ActiveRecord::Migration[5.1]
  def change
    remove_column :planes, :seat_map, :string
  end
end
