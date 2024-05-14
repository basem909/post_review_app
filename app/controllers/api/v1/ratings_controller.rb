# frozen_string_literal: true

module Api
  module V1
    # Controller for handling API requests related to ratings.
    class RatingsController < ApplicationController
      before_action :set_user, only: [:create]
      before_action :set_post, only: [:create]
      before_action :first_ratings?, only: [:create]

      def create
        # remember to validate existence
        rating = Rating.new(rating_params)

        if rating.save
          render json: { message: 'Rating sent successfully!' }, status: :ok
        else
          render json: { error: rating.errors }, status: :unprocessable_entity
        end
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def top_posts
        n = (params[:n] || 10).to_i
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 10).to_i

        posts = Post.left_joins(:ratings)
                    .group(:id)
                    .select('posts.id, posts.title, posts.body, AVG(ratings.value) AS average_rating')
                    .order('average_rating DESC')
                    .limit(n)
                    .offset((page - 1) * per_page)


        post_attributes = posts.map do |post|
          { id: post.id, title: post.title, body: post.body }
        end

        paginated_response = {
          current_page: page,
          per_page:,
          top_posts: post_attributes
        }

        render json: paginated_response, status: :ok
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      private

      def set_user
        @user = User.find_by(id: params[:user_id])
        return if @user

        render json: { error: "A valid user's id must be present" }, status: :unprocessable_entity and return
      end

      def set_post
        @post = Post.find_by(id: params[:post_id])
        render json: { error: 'A valid post id must be present' }, status: :unprocessable_entity and return unless @post

        # in case we won't allow the user to rate his own post this validation will prevent this case
        return unless @post.user_id == params[:user_id]

        render json: { error: 'A user can not rate his/her own posts' }, status: :unprocessable_entity and return
      end

      # validating that rating is the user's first on the post
      def first_ratings?
        rating = Rating.find_by(user_id: params[:user_id], post_id: params[:post_id])
        return unless rating

        render json: { error: 'You already rated this post' }, status: :unprocessable_entity
      end

      def rating_params
        params.permit(:user_id, :post_id, :value)
      end
    end
  end
end
