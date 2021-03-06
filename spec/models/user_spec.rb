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

    describe "authenticate method" do

      it "should return nil on email/password missmatch" do
        User.authenticate(@attr[:email], "wrongpass").should be_nil
      end

      it "should return nil for an email address with no user" do
        User.authenticate("wrong@email.su", @attr[:password]).should be_nil
      end

      it "it should return thr user on email/password match" do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end   
  end

  describe "admin attribute" do

    before do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "micropost associations" do

    before do
      @user = User.create(@attr)
      @mp1 = FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
      @mp2 = FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include the microposts from other users" do
        mp3 = FactoryGirl.create(:micropost, user: FactoryGirl.create(:user, email:"someuniqemail@test.net"))
        @user.feed.include?(mp3).should be_false
      end
    end
  end

  describe "Relationship" do

    before do
      @user = User.create!(@attr)
      @followed = FactoryGirl.create(:user)
    end

    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end
  end
end