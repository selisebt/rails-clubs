FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { Faker::Name.name }
    password { 'password123' }
    password_confirmation { 'password123' }
    association :role
  end
end
