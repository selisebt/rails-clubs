FactoryBot.define do
  factory :role do
    name { Faker::Company.unique.buzzword }
  end
end
