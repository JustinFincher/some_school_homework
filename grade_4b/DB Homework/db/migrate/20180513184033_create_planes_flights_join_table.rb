class CreatePlanesFlightsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :planes, :flights
  end
end
