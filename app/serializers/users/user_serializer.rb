# == Schema Information
#
# Table name: users_users
#
#  id              :integer          not null, primary key
#  nickname        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  role            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Users::UserSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :email, :role
end
