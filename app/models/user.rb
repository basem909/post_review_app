class User < ApplicationRecord
  include StringColumnsValidation

  # Relations
  has_many :posts
  has_many :ratings

  validate_short_string_columns login, presence: true, uniqueness: true, accept_special_char: true
end
