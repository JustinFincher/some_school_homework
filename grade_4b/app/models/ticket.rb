class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :flight
  belongs_to :price
end
