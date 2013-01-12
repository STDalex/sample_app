require 'spec_helper'

describe MicropostsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'delete'" do
      delete :destroy, id: 1
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'index'" do

    describe "for non-signed-in user" do

      it "should deny access" do
        user = FactoryGirl.create(:user)
        get :index, user_id: user
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed in user" do

      before do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
        @mp = []
        3.times do |n|
          @mp << FactoryGirl.create(:micropost, user: @user, content: "micropost #{n}")
        end
      end

      it "should be success" do
        get :index, user_id: @user
        response.should be_success
      end

      it "should have an element for each micropost" do
        get :index, user_id: @user
        @mp.each { |micropost| response.should have_selector("span.content", content: micropost.content) }
      end
    end
  end

  describe "POST 'create'" do

    before do
      @user = test_sign_in(FactoryGirl.create(:user))
    end

    describe "failure" do

      before do
        @attr = {content:""}
      end

      it "should not create a micropost" do
        lambda do
          post :create, micropost: @attr
        end.should_not change(Micropost, :count)
      end

      it "should render the home page" do
        post :create, micropost: @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do

      before do
        @attr = {content: "Lorem ipsum"}
      end

      it "should create the micropost" do
        lambda do
          post :create, micropost: @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, micropost: @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, micropost: @attr
        flash[:success].should =~ /micropost created/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an authorized user" do

      before do
        @user = test_sign_in(FactoryGirl.create(:user))
        @micropost = FactoryGirl.create(:micropost, user: @user)
      end

      it "should destroy the micropost" do
        lambda do
          delete :destroy, id: @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
  end
  
end