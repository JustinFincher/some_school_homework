class AddNameToPlaneBlueprints < ActiveRecord::Migration[5.1]
  def change
    add_column :plane_blueprints, :name, :string
  end
end
