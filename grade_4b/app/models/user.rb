class User < ApplicationRecord
  enum sex_type: [:male, :female, :not_known]
  has_many :tickets
end
