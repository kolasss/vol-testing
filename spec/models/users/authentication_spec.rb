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

require 'rails_helper'

RSpec.describe Users::Authentication, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:authentication)).to be_valid
  end
end
