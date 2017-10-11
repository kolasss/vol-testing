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

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :published_at, :author_nickname

  def author_nickname
    object.author.nickname
  end
end
