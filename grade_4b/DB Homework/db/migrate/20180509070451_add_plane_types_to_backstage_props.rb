class AddPlaneTypesToBackstageProps < ActiveRecord::Migration[5.1]
  def change
    add_column :backstage_props, :plane_types, :text
  end
end
