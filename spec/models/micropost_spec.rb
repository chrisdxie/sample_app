# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Micropost do


  let(:user) { FactoryGirl.create(:user) }
  before do
	@micropost = user.microposts.build( content: "First post!" )
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }

  it { should be_valid }

  its(:user) { should == user }

  describe "when user id is not present" do
	before { @micropost.user_id = nil }
	it { should_not be_valid }
  end

  describe "accessible attributes" do
	it "should not allow access to the user id" do
	  expect { Micropost.new( user_id: user.id ) }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
	end
  end

  describe "validations" do
	describe "with blank content" do
	  before { @micropost.content = " " }
	  it { should_not be_valid }
	end
	describe "over 140 characters" do
	  before { @micropost.content = 'a' * 141 }
	  it { should_not be_valid }
	end
  end
end
