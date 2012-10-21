require 'factory_girl'
FactoryGirl.define do
  factory :user do
    name "stadnitsky alexander"
    email "stadntskya@gmail.com"
    password "qwerty"
    password_confirmation "qwerty"
  end
end