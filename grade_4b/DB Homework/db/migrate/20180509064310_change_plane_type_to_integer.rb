class ChangePlaneTypeToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column(:planes, :type, :integer)
  end
end
