FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Lorem.characters 5 }
    password { Faker::Lorem.characters 8 }
  end
  factory :github_user, parent: :user do
    uid { rand(1000000..9999999).to_s }
    provider { :github }
  end
end