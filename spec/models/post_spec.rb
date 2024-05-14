# frozen_string_literal: true

RSpec.describe 'Post', type: :model do
  describe 'validations' do
    it 'validates presence of title' do
      post = Post.new(title: nil)
      post.valid?
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'validates presence of body' do
      post = Post.new(body: nil)
      post.valid?
      expect(post.errors[:body]).to include("can't be blank")
    end

    it 'validates length of body' do
      post = Post.new(body: 'a' * 1001)
      post.valid?
      expect(post.errors[:body]).to include('is too long (maximum is 1000 characters)')
    end

    it 'validates presence of IP address' do
      post = Post.new(ip: nil)
      post.valid?
      expect(post.errors[:ip]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'responds to user' do
      expect(Post.new).to respond_to(:user)
    end

    it 'responds to ratings' do
      expect(Post.new).to respond_to(:ratings)
    end
  end
end
