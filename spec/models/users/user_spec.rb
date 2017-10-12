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
#  avatar          :string
#

require 'rails_helper'

RSpec.describe Users::User, type: :model do
  describe "validations" do
    subject {
      described_class.new(
        nickname: Faker::Name.name,
        email:    Faker::Internet.unique.email,
        role:     "Blogger"
      )
    }
    it { is_expected.to validate_presence_of(:nickname) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_inclusion_of(:role).in_array(['Blogger', 'Administrator']) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:authentications).dependent(:destroy) }
    it { is_expected.to have_many(:posts).dependent(:destroy).with_foreign_key('author_id') }
    it { is_expected.to have_many(:comments).dependent(:destroy).with_foreign_key('author_id') }
  end

  describe 'scopes' do
    describe '.by_created' do
      let!(:users) { FactoryGirl.create_list(:user, 3) }

      it 'returns users sorted by created_at descending' do
        expect(described_class.by_created).to eq described_class.order(created_at: :desc)
      end
    end
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  describe '.find_by_auth_id' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:auth1) { FactoryGirl.create(:authentication, user: user1) }

    it "find user by authentication's id" do
      expect(described_class.find_by_auth_id auth1.id).to eq user1
    end

    it "do not find wrong user" do
      expect(described_class.find_by_auth_id auth1.id).to_not eq user2
    end
  end

  describe '#admin?' do
    let(:user1) { FactoryGirl.create(:user, role: 'Administrator') }
    let(:user2) { FactoryGirl.create(:user) }

    it 'return true for admin user'do
      expect(user1.admin?).to be true
    end

    it 'return false for not admin user'do
      expect(user2.admin?).to be false
    end
  end
end
