FactoryBot.define do
  factory :club do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
  end
end
