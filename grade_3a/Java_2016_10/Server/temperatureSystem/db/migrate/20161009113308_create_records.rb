class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.float :temperature
      t.datetime :datetime
      t.integer :user_id

      t.timestamps
    end
  end
end
