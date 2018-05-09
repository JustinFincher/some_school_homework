class Flight < ApplicationRecord
  enum type: [:a380, :b777]
end
