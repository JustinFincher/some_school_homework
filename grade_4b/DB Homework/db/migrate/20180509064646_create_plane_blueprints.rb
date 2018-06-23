class CreatePlaneBlueprints < ActiveRecord::Migration[5.1]
  def change
    create_table :plane_blueprints do |t|
      t.string :seat_map

      t.timestamps
    end
  end
end
