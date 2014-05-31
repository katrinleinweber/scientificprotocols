FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Lorem.characters 5 }
    password { Faker::Lorem.characters 8 }
  end
end