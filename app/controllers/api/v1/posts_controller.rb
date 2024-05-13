module Api
  module V1
    class PostsController < ApplicationController
  before_action :set_user, only: [:create]

  def create
    post = @user.posts.new(post_params)

    if post.save!
      render json: { message: "Post created successfully!", post: post, user: @user}, status: :ok
    else
      render json: { error: post.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(login: params[:login])
    unless @user
      render json: { error: "User's login must be present" }, status: :unprocessable_entity and return
    end
  end

  def post_params
    params.permit(:title, :body, :ip)
  end
end
end
end
