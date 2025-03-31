FactoryBot.define do
  factory :role do
    sequence(:name) { |n| ["admin", "member", "guest"][n % 3] }
    
    trait :admin do
      name { 'admin' }
    end
    
    trait :member do
      name { 'member' }
    end
    
    trait :guest do
      name { 'guest' }
    end
  end
end 