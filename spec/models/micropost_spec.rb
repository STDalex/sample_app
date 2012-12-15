require 'spec_helper'

describe Micropost do
  before do
    @user = FactoryGirl.create(:user)
    @attr = { content: "value for content" }
  end

  it "should create a new instance given valid attributes" do
    @user.microposts.create(@attr)
  end

  describe "user associations" do

    before do
      @micropost = @user.microposts.create(@attr)
    end

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end

  describe "validations" do

    it "should require user id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should have not blank content" do
      @user.microposts.build(@attr.merge(content:" ")).should_not be_valid
    end

    it "should reject to long content" do
      @user.microposts.build(@attr.merge(content: "a" * 141)).should_not be_valid
    end

  end
end
