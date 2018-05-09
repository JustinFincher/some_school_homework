class CreateBackstageProps < ActiveRecord::Migration[5.1]
  def change
    create_table :backstage_props do |t|

      t.timestamps
    end
  end
end
