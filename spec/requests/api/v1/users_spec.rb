require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST create' do
    context 'when user creation is successful' do
      it 'creates a new user and returns success status' do
        post :create, params: { login: 'john_doe' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('User created successfully!')
        expect(User.count).to eq(1)
        expect(User.last.login).to eq('john_doe')
      end
    end

    context 'when user creation fails' do
      it 'returns an error response' do
        post :create, params: { login: nil }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to_not be_empty
      end
    end
  end
end
