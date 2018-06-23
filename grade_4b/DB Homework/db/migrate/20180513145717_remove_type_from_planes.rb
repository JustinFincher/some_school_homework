class RemoveTypeFromPlanes < ActiveRecord::Migration[5.1]
  def change
    remove_column :planes, :type, :string
  end
end
