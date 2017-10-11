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

class Comment < ApplicationRecord
  belongs_to :author, class_name: 'Users::User'
  belongs_to :post

  validates :body, presence: true
  validates :published_at, presence: true
  validates :author, presence: true
  validates :post, presence: true

  scope :by_published, -> { order(published_at: :desc) }
end
