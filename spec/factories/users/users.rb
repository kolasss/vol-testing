FactoryGirl.define do
  factory :user, class: Users::User do
    nickname  { Faker::Name.name }
    email     { Faker::Internet.unique.email }
    password  "password"
    role      "Blogger"

    factory :user_with_auth do
      after(:create) do |user, evaluator|
        create_list(:authentication, 1, user: user)
      end
    end
  end
end
