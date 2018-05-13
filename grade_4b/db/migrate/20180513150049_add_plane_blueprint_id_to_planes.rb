class AddPlaneBlueprintIdToPlanes < ActiveRecord::Migration[5.1]
  def change
    add_column :planes, :plane_blueprint_id, :integer
  end
end
