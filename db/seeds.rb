require 'json'
require 'net/http'

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
        login: user.login,
        ip: ip
    }

    # Create the post
    begin
      post_response = execute_api_request('/api/v1/posts', 'POST', post)
      response_data = JSON.parse(post_response)
      post_id = response_data['post']['id']
    rescue StandardError => e
      puts "Failed to create post. Error: #{e.message}"
      next
    end

    # Create ratings for the post
    next unless n < num_ratings
    user_id = user.id.to_i - 1

    rating = {
        post_id: post_id,
        user_id: user_id,
        value: rand(1..5)
    }

    begin
      rating_response = execute_api_request('/api/v1/ratings', 'POST', rating)
      rating_data = JSON.parse(rating_response)

      if rating_data.key?("message")
        puts "Rating created successfully!"
      else
        puts "Failed to create rating. Error: #{rating_data['error']}"
      end
    rescue StandardError => e
      puts "Failed to create rating. Error: #{e.message}"
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
# create_users(100)

# Create posts and ratings
create_posts(200_000, 150_000)