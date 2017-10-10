# == Schema Information
#
# Table name: users_authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  info       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Users::Authentication < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
end
