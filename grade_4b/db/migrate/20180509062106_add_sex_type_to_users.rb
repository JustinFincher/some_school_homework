class AddSexTypeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sex_type, :integer
  end
end
