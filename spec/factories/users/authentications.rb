FactoryGirl.define do
  factory :authentication, class: Users::Authentication do
    user
  end
end
