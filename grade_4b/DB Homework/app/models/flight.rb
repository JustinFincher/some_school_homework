class Flight < ApplicationRecord
  has_and_belongs_to_many :planes
  has_many :prices
  has_many :tickets
  accepts_nested_attributes_for :prices,
                                :allow_destroy => true
end
