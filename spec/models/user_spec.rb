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
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require a email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are to long" do
    long_name = "a"*51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email address" do
    valid_addresses = %w(user@yandex.ru THE_USER@example.bar.org first.last@example.ru)
    valid_addresses.each do |address|
      valid_email_address = User.new(@attr.merge(:email => address))
      valid_email_address.should be_valid
    end
  end
  
  it "should reject invalid email address" do
    addresses = %w(user@yandex,com user_fail.org example.user@foo.)
    addresses.each do |address|
      invalid_email_address = User.new(@attr.merge(:email => address))
      invalid_email_address.should_not be_valid
    end
  end
      
end
