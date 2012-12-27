require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do

	it "should have as h1 'Sample App'" do 
	  visit root_path
	  page.should have_selector('h1', :text => 'Sample App')
    end

	it "should have as title 'Ruby on Rails Tutorial Sample App'" do
	  visit root_path
	  page.should have_selector('title', :text => 'Ruby on Rails Tutorial Sample App')
	end

	it "should not have 'Home' as part of title" do
	  visit root_path
	  page.should_not have_selector('title', :text => '| Home')
	end

  end

  describe "Help page" do

	it "should have as h1 'Help'" do
	  visit help_path
	  page.should have_selector('h1', :text => 'Help')
	end

	it "should have as title 'Help'" do
	  visit help_path
	  page.should have_selector('title', :text => 'Ruby on Rails Tutorial Sample App | Help')
	end

  end

  describe "About page" do

	it "should have as h1 'About Us'" do
	  visit about_path
	  page.should have_selector('h1', :text => 'About')
	end

	it "should have as title 'About Us'" do
	  visit about_path
	  page.should have_selector('title', :text => 'Ruby on Rails Tutorial Sample App | About Us')
	end

  end

  describe "Contact page" do

	it "should have the h1 'Contact'" do
	  visit contact_path
	  page.should have_selector('h1', text: 'Contact')
	end

	it "should have the title 'Contact'" do
	  visit contact_path
	  page.should have_selector('title', text: 'Contact')
	end

  end

end
