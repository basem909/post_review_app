module Api
module V1
class UsersController < ApplicationController

  def create
    user = User.new(user_params)

    if user.save
      render json: { message: "User created successfully!", user: user }, status: :ok
    else
      render json: { error: user.errors }
    end
  end

  private
  def user_params
    params.permit(:login)
  end
end
end
end
