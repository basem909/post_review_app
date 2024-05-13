# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { User.new(login: 'john_doe') }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'validates presence of login' do
      subject.login = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:login]).to include("can't be blank")
    end

    it 'validates uniqueness of login' do
      User.create(login: 'john_doe')
      subject.login = 'john_doe'
      expect(subject).not_to be_valid
      expect(subject.errors[:login]).to include('has already been taken')
    end
  end

  it 'responds to posts' do
    expect(subject).to respond_to(:posts)
  end

  it 'responds to ratings' do
    expect(subject).to respond_to(:ratings)
  end
end
