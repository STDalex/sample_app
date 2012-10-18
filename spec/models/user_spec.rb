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
    @attr = { 
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
      }
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
  
  it "should reject duplicate email address" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcase_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcase_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "password validation" do
    
    it "should require a password" do
      no_password_user = User.new(@attr.merge(:password => "", :password_confirmation =>""))
      no_password_user.should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    
    it "should reject a short password" do
      short = "a"*5
      User.new(@attr.merge(:password => short, :password_confirmation => short)).should_not be_valid
    end
    
    it "should reject a very long password" do
      long = "a"*41
      User.new(@attr.merge(:password => long, :password_confirmation => long)).should_not be_valid
    end
    
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    it "has_password? should be true if password match" do
      @user.has_password?(@attr[:password]).should be_true
    end
    
    it "has_password? should be false if password not match" do
      @user.has_password?('invalid').should_not be_true
    end
    
  end
  

end
