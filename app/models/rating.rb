class Rating < ApplicationRecord
  include NumberColumnsValidation 

  # Relations
  belongs_to :post
  belongs_to :user

  # Validations
  validates :value, presence: true
  validates :value, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, message: 'must be an integer between 1 and 5' }
end
