# frozen_string_literal: true

# rubocop:disable all

require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  describe 'POST create' do
    let(:user) { create(:user) }

    context 'when post creation is successful' do
      it 'creates a new post and returns success status' do
        post :create, params: { login: user.login, title: 'Test Title', body: 'Test Body', ip: '127.0.0.1' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Post created successfully!')
        expect(JSON.parse(response.body)['post']).to_not be_nil
        expect(JSON.parse(response.body)['user']).to_not be_nil
        expect(user.posts.count).to eq(1)
      end
    end

    context 'when post creation fails' do
      it 'returns an error response' do
        post :create, params: { post: { title: 'Sample Title', body: 'Sample Body', ip: '127.0.0.1' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to_not be_empty
        expect(user.posts.count).to eq(0)
      end
    end

    context 'when user is not found' do
      it 'returns an error response' do
        post :create, params: { login: 'non_existent_user', title: 'Test Title', body: 'Test Body', ip: '127.0.0.1' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq("User's login must be present")
      end
    end
  end

  describe 'GET ips_with_multiple_authors' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }

    it 'returns the IPs with multiple authors' do
      create(:post, user: user1, ip: '127.0.0.1')
      create(:post, user: user2, ip: '127.0.0.1')
      create(:post, user: user3, ip: '127.0.0.2')

      get :ips_with_multiple_authors

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([{ 'ip' => '127.0.0.1', 'authors' => [user1.login, user2.login] }])
    end
  end
end
