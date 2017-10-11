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

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validations" do
    subject {
      described_class.new(
        title:        Faker::StarWars.character,
        body:         Faker::StarWars.quote,
        published_at: Faker::Time.between(2.days.ago, Date.today, :all),
        author:       FactoryGirl.build(:user)
      )
    }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:published_at) }
    it { is_expected.to validate_presence_of(:author) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:author).class_name('Users::User') }
  end

  describe 'scopes' do
    describe '.by_published' do
      let!(:posts) {
        [
          FactoryGirl.create(:post),
          FactoryGirl.create(:post),
          FactoryGirl.create(:post)
        ]
      }

      it 'returns posts sorted by published_at descending' do
        expect(described_class.by_published).to eq described_class.order(published_at: :desc)
      end
    end
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:post)).to be_valid
  end
end
