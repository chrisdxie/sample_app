# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before { @user = User.new( name: "Example",
							 email: "user@example.com", 
							 password: "foobar",
							 password_confirmation: "foobar" ) }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when name is not present" do

	before { @user.name = '' }
	it { should_not be_valid }

  end

  describe "when email is not present" do

	before { @user.email = ' ' }
	it { should_not be_valid }

  end

  describe "when name is too long" do

	before { @user.name = ('a' * 51) }
	it { should_not be_valid }

  end

  describe "when email is invalid" do

	it "should be invalid" do
	  addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com ]
	  addresses.each do |address|
		@user.email = address
		@user.should_not be_valid
	  end
	end
  end

  describe "when email is valid" do

	it "should be valid" do
	  addresses = %w[user@foo.com example.user@foo.com foo_bar-baz@foobar.com first.lst@foo.jp a+b@bar.com]
	  addresses.each do |address|
		@user.email = address
		@user.should be_valid
	  end
	end
  end

  describe "when email is already taken" do

	before do
	  user_with_same_email = @user.dup
	  user_with_same_email.email = @user.email.upcase
	  user_with_same_email.save
	end

	it { should_not be_valid }

  end

  describe "when password is not present" do

	before { @user.password = @user.password_confirmation = '' }
	it { should_not be_valid }
  end

  describe "when password confirmation does not match password" do

	before { @user.password_confirmation = "mismatch" }
	it { should_not be_valid }
  end

  describe "when password confirmation is nil" do

	before { @user.password_confirmation = nil }
	it { should_not be_valid }
  end

  describe "return value of authenticate method" do

	before { @user.save }
	let(:found_user) { User.find_by_email(@user.email) }

	describe "with valid password" do
	  it { should == found_user.authenticate(@user.password) }
	end

	describe "with invalid password" do
	  let(:user_with_invalid_password) { found_user.authenticate("invalid") }
	  
	  it { should_not == user_with_invalid_password }
	  specify { user_with_invalid_password.should be_false }
	end
  end

  describe "with a password that is too short" do

	before { @user.password = @user.password_confirmation =  'a' * 5 }
	it { should be_invalid}
  end
end
