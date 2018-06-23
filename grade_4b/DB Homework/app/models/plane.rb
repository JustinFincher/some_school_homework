class Plane < ApplicationRecord
  belongs_to :plane_blueprint
  has_and_belongs_to_many :flights
end
