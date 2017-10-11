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

class Post < ApplicationRecord
  belongs_to :author, class_name: 'Users::User'

  validates :title, presence: true
  validates :body, presence: true
  validates :published_at, presence: true
  validates :author, presence: true

  scope :by_published, -> { order(published_at: :desc) }
end
