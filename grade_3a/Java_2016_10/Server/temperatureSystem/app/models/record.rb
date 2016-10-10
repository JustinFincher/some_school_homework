class Record < ApplicationRecord
  belongs_to :user
  default_value_for :datetime do
    Time.now
  end
end
