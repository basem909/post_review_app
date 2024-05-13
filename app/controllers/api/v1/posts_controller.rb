# frozen_string_literal: true

module Api
  module V1
    # Controller for handling API requests related to posts.
    class PostsController < ApplicationController
      before_action :set_user, only: [:create]

      def create
        post = @user.posts.new(post_params)

        if post.save!
          render json: { message: 'Post created successfully!', post:, user: @user }, status: :ok
        else
          render json: { error: post.errors }, status: :unprocessable_entity
        end
      end

      def ips_with_multiple_authors
        ips_with_authors = Post.includes(:user)
                               .group(:ip)
                               .having('COUNT(DISTINCT user_id) > 1')
                               .pluck(:ip, 'array_agg(users.login)')

        result = ips_with_authors.map do |ip, authors|
          { ip:, authors: }
        end

        render json: result
      end

      private

      def set_user
        @user = User.find_by(login: params[:login])
        return if @user

        render json: { error: "User's login must be present" }, status: :unprocessable_entity and return
      end

      def post_params
        params.permit(:title, :body, :ip)
      end
    end
  end
end
