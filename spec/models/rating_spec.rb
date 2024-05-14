# frozen_string_literal: true

# rubocop:disable all

RSpec.describe 'Rating', type: :model do
  describe 'associations' do
    it 'responds to post' do
      expect(Rating.new).to respond_to(:post)
    end

    it 'responds to user' do
      expect(Rating.new).to respond_to(:user)
    end
  end

  describe 'validations' do
    it 'validates presence of value' do
      rating = Rating.new(value: nil)
      rating.valid?
      expect(rating.errors[:value]).to include("can't be blank")
    end

    it 'validates numericality of value' do
      rating = Rating.new(value: 'abc')
      rating.valid?
      expect(rating.errors[:value]).to include('must be an integer between 1 and 5')
    end

    it 'validates value within the range of 1 to 5' do
      rating = Rating.new(value: 6)
      rating.valid?
      expect(rating.errors[:value]).to include('must be an integer between 1 and 5')
    end

    it 'validates value within the range of 1 to 5' do
      rating = Rating.new(value: 0)
      rating.valid?
      expect(rating.errors[:value]).to include('must be an integer between 1 and 5')
    end
  end
end
