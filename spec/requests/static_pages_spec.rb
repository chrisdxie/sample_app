require 'spec_helper'

describe "StaticPages" do

  subject { page } 

  describe "Home page" do
	before { visit root_path }

	it { should have_selector('h1', text: 'Sample App') }
	it { should have_selector('title', text: full_title('')) }
	it { should_not have_selector('title', text: full_title('Home')) }

	describe "for signed-in users" do
	  let(:user) { FactoryGirl.create(:user) }
	  before do
		FactoryGirl.create(:micropost, user: user, content: "First")
		FactoryGirl.create(:micropost, user: user, content: "Second")
		sign_in user
		visit root_path
	  end

	  it "should render the users feed" do
		user.feed.each do |post|
		  page.should have_selector("li##{post.id}", text: post.content)
		end
	  end

	  describe "followers/following count" do
		let(:other_user) { FactoryGirl.create(:user) }
	 	before do
		  other_user.follow!(user)
		  visit root_path
		end

		it { should have_link("0 following", href: following_user_path(user)) }
		it { should have_link("1 followers", href: followers_user_path(user)) }
	  end
	end
  end

  describe "Help page" do
	before { visit help_path }

	it {should have_selector('h1', text: 'Help') }
	it {should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
	before { visit about_path }

	it { should have_selector('h1', text: 'About') }
	it { should have_selector('title', text: full_title('About Us')) }
  end

  describe "Contact page" do
	before { visit contact_path }

	it { should have_selector('h1', text: 'Contact') }
	it { should have_selector('title', text: full_title('Contact')) }
  end

end
