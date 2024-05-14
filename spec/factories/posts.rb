# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    title { 'Sample Title' }
    body { 'Sample Body' }
    ip { '127.0.0.1' }
    user  # Assuming you have an association with the User model
  end
end