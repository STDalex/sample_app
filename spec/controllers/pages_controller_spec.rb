require 'spec_helper'

describe PagesController do
 before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

render_views

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => @base_title + "Home")
    end

    describe "GET 'home' by sign in user" do

      before do
        @user = test_sign_in(FactoryGirl.create(:user))
      end

      it "should have right count user's microposts" do
        mp = FactoryGirl.create(:micropost, user: @user)
        get 'home'
        response.should have_selector("span.microposts", content: "1 micropost")
      end
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", :content => @base_title + "Contact")
    end
  end
  
  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
    it "should have the right title" do
      get 'about'
      response.should have_selector("title", :content => @base_title + "About")
    end
  end
  
  describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      response.should be_success
    end
    it "should have the right title" do
      get 'help'
      response.should have_selector("title", :content => @base_title + "Help")
    end
  end 

end
