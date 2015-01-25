FactoryGirl.define do
  factory :rating do
    association :user, factory: :user
    association :protocol, factory: :protocol
    score 1
  end
end
