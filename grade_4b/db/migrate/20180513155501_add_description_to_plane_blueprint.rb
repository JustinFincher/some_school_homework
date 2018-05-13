class AddDescriptionToPlaneBlueprint < ActiveRecord::Migration[5.1]
  def change
    add_column :plane_blueprints, :description, :text
  end
end
