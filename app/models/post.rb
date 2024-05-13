class Post < ApplicationRecord
  include StringColumnsValidation

  # Relations
  belongs_to :user
  has_many :ratings, dependent: :destroy

  # Validations
  validate_short_string_columns :title, presence: true
  validate_long_string_column :body, presence: true, maximum: 1000,  allow_blank: false
  validates :ip, presence: true
end
