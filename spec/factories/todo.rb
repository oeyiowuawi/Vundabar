FactoryGirl.define do
  factory :todo do
    title { Faker::Internet.name }
    body "body"
    status "pending"
    created_at Time.now.to_s
  end
end
