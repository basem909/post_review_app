# The StringColumnValidator module provides common validations for string columns like name, first_name, last_name, etc..
# It includes validations for common string columns like name, first_name, last_name, etc..
#
module StringColumnsValidation
  extend ActiveSupport::Concern

  class_methods do
    # Dynamically adds validations for specified short string columns based on provided criteria.
    # It validates the length, format, presence, and uniqueness (optional) of each column.
    # The default format allows letters, spaces, underscores, and dashes only.
    #
    # @param columns [Array<Symbol>] The names of the columns to validate.
    # @param presence [Boolean] Specifies whether the presence of the column's value is required.
    #   Defaults to false.
    # @param maximum [Integer] The maximum length allowed for the column's value.
    #   Defaults to 50.
    # @param uniqueness [Boolean] Specifies whether the column's value must be unique.
    #   Defaults to false.
    # @param allow_blank [Boolean] Specifies whether the column's value can be blank.
    #   Defaults to true.
    #
    # @example Add validations to the :first_name and :last_name columns
    #   validate_short_string_columns(:first_name, :last_name, presence: true, uniqueness: true, allow_blank: false)
    #
    # @example Add validations to the :bio column with custom maximum length
    #   validate_short_string_columns(:bio, maximum: 100, allow_blank: true)
    def validate_short_string_columns(*columns , presence: false, maximum: 50, uniqueness: false,  allow_blank: true, accept_special_char: false )
      columns.each do |column|
        if accept_special_char
          validates column, format: { with: /\A[A-Za-z0-9@#$%^&*()\[\]{}\-_+=|\\\/.,:;"'<>?!]+\z/, message: "should only contain numbers, characters, and special characters" }
        else
          validates column, format: { with: /\A[a-zA-Z0-9\s_-]+\z/, message: "Only allows letters, numbers, spaces, underscores, and dashes" }, allow_blank: allow_blank
        end
        validates column, length: { minimum: 3, maximum: maximum }
        validates column, presence: true if presence
        validates column, uniqueness: { case_sensitive: false } if uniqueness
      end
    end
    # Dynamically adds validations for specified long string columns based on provided criteria.
    # It validates the length and, optionally, the presence, allowance of blank values,
    # and inclusion of special characters in each column. By default, it allows letters,
    # spaces, underscores, and dashes only unless `characters_restriction` is set to true.
    #
    # @param columns [Array<Symbol>] The names of the columns to validate.
    # @param presence [Boolean] Specifies whether the presence of the column's value is required.
    #   Defaults to false.
    # @param maximum [Integer] The maximum length allowed for the column's value.
    #   Defaults to 500.
    # @param allow_blank [Boolean] Specifies whether the column's value can be blank.
    #   Defaults to true.
    # @param characters_restriction [Boolean] If true, relaxes the format constraint to
    #   allow characters beyond letters, spaces, underscores, and dashes.
    #   Defaults to false.
    #
    # @example Add validations to the :description column with default settings
    #   validate_long_string_column(:description)
    #
    # @example Add validations to multiple columns with custom settings
    #   validate_long_string_column(:description, :comments, presence: true, allow_blank: false, characters_restriction: true)
    def validate_long_string_column(*columns, presence: false, maximum: 500,  allow_blank: true, characters_restriction: false)
      columns.each do |column|
        validates :description, length: { minimum: 3, maximum: maximum }, allow_blank: allow_blank
        validates column, presence: true if presence
        validates column, format: { with: /\A[a-zA-Z\s_-]+\z/, message: "Only allows letters, spaces, underscores, and dashes" } if characters_restriction
      end
    end
  end
end
