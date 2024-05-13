class Api::V1::RatingsController < ApplicationController

  before_action :set_user, only: [:create]
  before_action :set_post, only: [:create]
  before_action :is_first_ratings, only: [:create]

  def create
    # remember to validate existence
    rating = Rating.new(rating_params)

    if rating.save
      render json: { message: "Rating sent successfully!" }, status: :ok
    else
      render json: { error: rating.errors }, status: :unprocessable_entity
    end
  end

  def top_posts
    n = params[:n].to_i # Number of top posts to retrieve
        posts = Post.left_joins(:ratings)
                    .group(:id)
                    .select("posts.id, posts.title, posts.body, AVG(ratings.value) AS average_rating")
                    .order("average_rating DESC")
                    .limit(n)

        post_attributes = posts.map do |post|
          { id: post.id, title: post.title, body: post.body }
        end

        render json: { top_posts: post_attributes }, status: :ok
  end

  private
  
  def set_user
    @user = User.find_by(id: params[:user_id])
    unless @user
      render json: { error: "A valid user's id must be present" }, status: :unprocessable_entity and return
    end
  end

  def set_post
    @post = Post.find_by(id: params[:post_id])
    unless @post
      render json: { error: "A valid post id must be present" }, status: :unprocessable_entity and return
    end

    # in case we won't allow the user to rate his own post this validation will prevent this case
    if @post.user_id == params[:user_id]
      render json: { error: "A user can not rate his/her own posts" }, status: :unprocessable_entity and return
    end
  end

  def is_first_ratings
    rating = Rating.find_by(user_id: params[:user_id], post_id: params[:post_id])
    if rating
      render json: { error: "You already rated this post" }, status: :unprocessable_entity
    end
  end

  def rating_params
    params.permit(:user_id, :post_id, :value)
  end
end
