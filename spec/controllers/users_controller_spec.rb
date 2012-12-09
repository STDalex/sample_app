require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do

    it "returns http success" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end

    it "should have a 'name' field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have a 'email' field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end

    it "should have a 'password' field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end

    it "should have a 'password confirmation' field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end

    it "should have a submit button" do
      get :new
      response.should have_selector("input[name='commit'][type='submit']")
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "should be successful" do
      get :show, id: @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, id: @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, id: @user
      response.should have_selector("title", content: @user.name)
    end

    it "should include user's name" do
      get :show, id: @user
      response.should have_selector("h1", content: @user.name)
    end

    it "should hame a profile image" do
      get :show, id: @user
      response.should have_selector("h1>img", class:"gravatar")
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before do
        @attr = {name:"", email:"", password:"q", password_confirmation:"wer"}
      end

      it "should not create a user" do
        lambda do
          post :create, user: @attr
        end.should_not change(User,:count)
      end

      it "should have the right title" do
        post :create, user: @attr
        response.should have_selector('title', content: "Sign up")
      end

      it "should render the 'new' page" do
        post :create, user: @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before do
        @attr = {name:"example user", email:"example@mail.com", password:"foobar", password_confirmation:"foobar"}
      end

      it "should create a user" do
        lambda do
          post :create, user: @attr
        end.should change(User,:count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, user: @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, user: @attr
        flash[:success].should =~ /welcome to the sample app/i 
      end

      it "should sign the user in" do
        post :create, user: @attr
        controller.should be_signed_in
      end
    end
  end

  describe "GET 'edit'" do

    before do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, id: @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, id: @user
      response.should have_selector("title", content:"Edit user")
    end

    it "should have the link to change gravatar" do
      get :edit, id: @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", href: gravatar_url, content:"change")
    end
  end

  describe "PUT 'update" do

    before do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before do
        @attr = { email:"", name:"", password:"", password_confirmation:""}
      end

      it "should render the edit page new" do
        put :update, id: @user, user: @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, id: @user, user: @attr
        response.should have_selector('title', content:"Edit user")
      end
    end

    describe "succssful" do

      before do
        @attr = { email:"valid@email.com", name:"valid", password:"validpass", password_confirmation:"validpass"}
      end

      it "should change the user's attribute" do
        put :update, id: @user, user: @attr
        @user.reload
        @user.name.should == @attr[:name] 
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, id: @user, user: @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have the flash message" do
        put :update, id: @user, user: @attr
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "authentication of edit/update pages" do
    before do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, id: @user
        response.should redirect_to(signin_path)        
      end

      it "should deny access to 'update'" do
        put :update, id: @user, user: {}
        response.should redirect_to(signin_path)
      end
    end

    describe "for sign-in users" do
      before do
        wrong_user = FactoryGirl.create(:user, email: "wrong.user@example.com")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, id: @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, id: @user, user:{}
        response.should redirect_to(root_path)
      end
    end
  end

  describe "GET 'index'" do

    describe 'for non-signed-in user' do

      it 'should deny access' do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe 'for sign-in user' do

      before do
        @user = test_sign_in(FactoryGirl.create(:user))
        second = FactoryGirl.create(:user, name:"Bob", email:"bobmail@example.com")
        third = FactoryGirl.create(:user, name:"Ron", email:"ronmail@example.com")
        @users = [@user, second, third]
        30.times do |n|
          @users << FactoryGirl.create(:user, email:"example#{n+1}@ax.com")
        end
      end

      it 'should be successful' do
        get :index
        response.should be_success
      end

      it 'should have the right title' do
        get :index
        response.should have_selector("title", content:"All users")
      end

      it 'should have an element for each user' do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", content:user.name)
        end
      end

      it 'should paginate users' do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.previous_page.disabled", content:"Previous")
        response.should have_selector("a", href:"/users?page=2", content:"2")
        response.should have_selector("a", href:"/users?page=2", content:"Next")
      end

    end
  end

end