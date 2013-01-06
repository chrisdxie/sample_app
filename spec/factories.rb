FactoryGirl.define do
  factory :user do
	name 	"Example"
	email	"example@user.com"
	password	"foobar"
	password_confirmation	"foobar"
  end
end
