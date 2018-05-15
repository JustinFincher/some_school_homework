class Flight < ApplicationRecord
  has_and_belongs_to_many :planes
  has_many :prices
  has_many :tickets
end
