# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  body         :text             not null
#  published_at :datetime         not null
#  post_id      :integer          not null
#  author_id    :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :comment do
    body          { Faker::Overwatch.quote }
    published_at  { Faker::Time.between(post.published_at, Date.today, :all) }
    association :author, factory: :user
    post
  end
end
