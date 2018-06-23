class User < ApplicationRecord
  enum sex_type: [:male, :female, :others]
  has_many :tickets
end
