# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
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
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:followers) }

  it { should respond_to(:remember_token) }

  it { should be_valid }

  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
	before do
	  @user.save!
	  @user.toggle!(:admin)
	end

	it { should be_admin }
  end

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

  describe "remember token" do
	before { @user.save }
	its(:remember_token) { should_not be_blank }
	# Equivalent to: it { @user.remember_token.should_not be_blank }

  end

  describe "microposts" do

	before { @user.save }
	let!(:older_post) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }
	let!(:newer_post) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }

	it "should have microposts in the right order" do
	  @user.microposts.should == [newer_post, older_post]
	end

	it "should destroy user micropsts" do
	  microposts = @user.microposts.dup
	  @user.destroy
	  microposts.should_not be_empty
	  microposts.each do |post|
		Micropost.find_by_id(post.id).should be_nil
	  end
	end

	describe "associations" do

	  let(:unfollowed_post) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
	  
	  its(:feed) { should include(older_post) }
	  its(:feed) { should include(newer_post) }
	  its(:feed) { should_not include(unfollowed_post) }

	  describe "followed posts" do

		let(:followed_user) { FactoryGirl.create(:user) }
		before do
		  3.times { followed_user.microposts.create!( content: "Yeah!" ) }
		  @user.follow!(followed_user)
		end

		its(:feed) { should include(older_post) }
		its(:feed) { should include(newer_post) }
		its(:feed) { should_not include(unfollowed_post) }
		its(:feed) do
		  followed_user.microposts.each do |post|
			should include(post)
		  end
		end
	  end
	end
  end

  describe "following" do

	let(:other_user) { FactoryGirl.create(:user) }
	before do
	  @user.save
	  @user.follow!(other_user)
	end

	it { should be_following(other_user) }
	its(:followed_users) { should include(other_user) }

	describe "and unfollowing" do
	  before { @user.unfollow!(other_user) }
	  it { should_not be_following(other_user) }
	  its(:followed_users) { should_not include(other_user) }
	end

	describe "followed user" do
	  subject { other_user }
	  its(:followers) { should include(@user) }
	end
  end
end
