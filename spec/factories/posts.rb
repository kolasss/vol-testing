# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  body         :text             not null
#  author_id    :integer          not null
#  published_at :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :post do
    title         { Faker::StarWars.character }
    body          { Faker::StarWars.quote }
    published_at  { Faker::Time.between(3.days.ago, 1.days.ago, :all) }
    association :author, factory: :user
  end
end
