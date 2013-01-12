require 'factory_girl'
FactoryGirl.define do

  factory :user do
    name "stadnitsky alexander"
    sequence(:email) {|n| "email#{n}@factory.com" }
    password "qwerty"
    password_confirmation "qwerty"
  end

  factory :micropost do
    content "Foo bar"
    association :user
  end
end