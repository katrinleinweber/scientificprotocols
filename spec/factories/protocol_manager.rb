FactoryGirl.define do
  factory :protocol_manager do
    association :user, factory: :user
    association :protocol, factory: :protocol
  end
end