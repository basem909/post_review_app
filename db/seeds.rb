# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'json'
require 'open-uri'

def create_users(num_users)
  num_users.times do |n|
    login = "user#{n + 1}"
    User.create!(login: login)
  end
end

def create_posts(num_posts, num_ratings)
  users = User.all.to_a
  ips = Array.new(50) { "192.168.0.#{rand(1..255)}" }

  num_posts.times do |n|
    user = users.sample
    ip = ips.sample

    post = {
      title: "Post #{n + 1}",
      body: "This is post #{n + 1}",
      user_id: user.id,
      ip: ip
    }

    # Create the post
    response = execute_api_request('/api/v1/posts', 'POST', post)
    post_id = JSON.parse(response)['id']

    # Create ratings for the post
    if n < num_ratings
      rating = {
        post_id: post_id,
        user_id: user.id,
        value: rand(1..5)
      }
      execute_api_request('/api/v1/ratings', 'POST', rating)
    end
  end
end

def execute_api_request(endpoint, method, data)
  url = "http://localhost:3000#{endpoint}"
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)

  request = case method
            when 'GET'
              Net::HTTP::Get.new(uri.request_uri)
            when 'POST'
              Net::HTTP::Post.new(uri.request_uri)
            else
              raise "Invalid HTTP method: #{method}"
            end

  request['Content-Type'] = 'application/json'
  request.body = data.to_json

  response = http.request(request)
  response.body
end

# Create users
create_users(100)

# Create posts and ratings
create_posts(200_000, 150_000)