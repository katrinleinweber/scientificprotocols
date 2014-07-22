# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do
    token { Faker::Lorem.characters }
    association :user, factory: :user
  end
end
