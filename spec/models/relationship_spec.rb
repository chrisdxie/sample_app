# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Relationship do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }
  it { should respond_to(:followed) }
  it { should respond_to(:follower) }
  its(:followed) { should == followed }
  its(:follower) { should == follower }


  describe "accessible attributes" do

	it "should not allow access to the follower id" do
	  expect do
		Relationship.new(follower_id: follower.id)
	  end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
	end
  end

  describe "when followed id is not present" do
	before { relationship.followed_id = nil }
	it { should_not be_valid }
  end

  describe "when follower id is not present" do
	before { relationship.follower_id = nil }
	it { should_not be_valid }
  end

end
