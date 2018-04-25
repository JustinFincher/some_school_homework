class CreateFlights < ActiveRecord::Migration[5.1]
  def change
    create_table :flights do |t|
      t.string :name
      t.string :number

      t.timestamps
    end
  end
end
