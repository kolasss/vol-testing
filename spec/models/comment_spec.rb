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

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validations" do
    let(:post) { FactoryGirl.build(:post) }
    subject {
      described_class.new(
        body:         Faker::Overwatch.quote,
        published_at: Faker::Time.between(post.published_at, Date.today, :all),
        author:       FactoryGirl.build(:user),
        post:         post
      )
    }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:published_at) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:post) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:author).class_name('Users::User') }
    it { is_expected.to belong_to(:post) }
  end

  describe 'scopes' do
    describe '.by_published' do
      let!(:comments) { FactoryGirl.create_list(:comment, 3) }

      it 'returns posts sorted by published_at descending' do
        expect(described_class.by_published).to eq described_class.order(published_at: :desc)
      end
    end
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:comment)).to be_valid
  end
end
