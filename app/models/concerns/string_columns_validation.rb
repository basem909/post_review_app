# frozen_string_literal: true
# rubocop:disable all

# The StringColumnValidator module provides common validations for string columns like name, first_name, last_name, etc..
# It includes validations for common string columns like name, first_name, last_name, etc..
#
module StringColumnsValidation
  extend ActiveSupport::Concern

  class_methods do
    def validate_short_string_columns(*columns, presence: false, maximum: 50, uniqueness: false, allow_blank: true,
                                      accept_special_char: false)
      columns.each do |column|
        if accept_special_char
          validates column,
                    format: { with: %r{\A[A-Za-z0-9@#$%^&*()\[\]{}\-_+=|\\/.,:;"'<>?!]+\z},
                              message: 'should only contain numbers, characters, and special characters' }
        else
          validates column,
                    format: { with: /\A[a-zA-Z0-9\s_-]+\z/, message: 'Only allows letters, numbers, spaces, underscores,
                     and dashes' }, allow_blank: end
        validates column, length: { minimum: 3, maximum: }
        validates column, presence: true if presence
        validates column, uniqueness: { case_sensitive: false } if uniqueness
      end
    end

    def validate_long_string_column(*columns, presence: false, maximum: 500, allow_blank: true,
                                    characters_restriction: false)
      columns.each do |column|
        validates(column, length: { minimum: 3, maximum: }, allow_blank:)
        validates column, presence: true if presence
        next unless characters_restriction

        validates column, format: { with: /\A[a-zA-Z\s_-]+\z/,
                                    message: 'Only allows letters, spaces, underscores, and dashes' }
      end
    end
  end
end
