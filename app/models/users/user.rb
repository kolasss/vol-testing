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

class Users::User < ApplicationRecord
  has_secure_password

  has_many :authentications, dependent: :destroy
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy

  USER_ROLES = [
    'Blogger',
    'Administrator'
  ]

  validates :email,
    uniqueness: { case_sensitive: false },
    presence: true,
    format: { with: /@/ }
  validates :nickname, presence: true
  validates :role, inclusion: { in: USER_ROLES }

  scope :by_created, -> { order(created_at: :desc) }

  def self.find_by_auth_id auth_id
    joins(:authentications).merge(Users::Authentication.where id: auth_id).first
  end

  def admin?
    self.role == 'Administrator'
  end
end
