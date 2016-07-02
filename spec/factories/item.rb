FactoryGirl.define do
  factory :item do
    title { Faker::Internet.name }
  end
end
