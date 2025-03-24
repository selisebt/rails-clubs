FactoryBot.define do
  factory :club do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    #
    # transient do
    #   user { nil }
    # end
    #
    # after(:create) do |club, evaluator|
    #   if evaluator.user
    #     create(:membership, club: club, user: evaluator.user)
    #   end
    # end
  end
end
