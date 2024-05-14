# frozen_string_literal: true

module Api
  module V1
    # Controller for handling API requests related to users.
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)

        if user.save
          render json: { message: 'User created successfully!', user: }, status: :ok
        else
          render json: { error: user.errors }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:login)
      end
    end
  end
end
