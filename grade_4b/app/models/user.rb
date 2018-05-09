class User < ApplicationRecord
  enum sex_type: [:male, :female, :not_known]
end
