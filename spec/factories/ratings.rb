# spec/factories/ratings.rb
FactoryBot.define do
  factory :rating do
    value { 5 }
    association :user
    association :post
  end
end