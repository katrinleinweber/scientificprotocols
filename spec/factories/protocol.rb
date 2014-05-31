FactoryGirl.define do
  factory :protocol do
    title { Faker::Lorem.sentence 5 }
    description { Faker::Lorem.paragraph 3 }
    gist_id { Faker::Lorem.characters 7 }
  end
end