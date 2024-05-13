class User < ApplicationRecord
  include StringColumnsValidation

  validate_short_string_columns login, presence: true, uniqueness: true, accept_special_char: true
end
