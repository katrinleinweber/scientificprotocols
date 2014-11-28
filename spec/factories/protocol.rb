FactoryGirl.define do
  factory :protocol do
    title { Faker::Lorem.sentence 5 }
    description { Faker::Lorem.paragraph 3 }
    gist_id { Faker::Lorem.characters 7 }
    octokit_client { Octokit::Client.new(access_token: Rails.configuration.api_github) }
    trait :published do
      workflow_state :published
    end
  end
end