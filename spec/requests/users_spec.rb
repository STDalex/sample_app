require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         with: ""
          fill_in "Email",        with: ""
          fill_in "Password",     with: "qw"
          fill_in "Confirmation", with: "wq"
          click_button "Sign Up"
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
          response.should have_selector("input[name='user[password]'][type='password']",content:"")
          response.should have_selector("input[name='user[password_confirmation]'][type='password']",content:"")
        end.should_not change(User, :count)
      end

    end

    describe "success" do

      it "should save new user" do
        lambda do
          visit signup_path
          fill_in :user_name, with: "example user2"
          fill_in :user_email, with: "examle2@exuser.com"
          fill_in :user_password, with: "foobar"
          fill_in :user_password_confirmation, with: "foobar"
          click_button "Sign Up"
          response.should render_template('users/show')
          response.should have_selector("div.flash.success", content:"Welcome")
        end.should change(User, :count).by(1)
      end

    end

  end

  describe "sign in/out" do

    describe "failure" do

      it "shoud not sign in" do
        visit '/'
        click_link "Sign in"
        fill_in :email, with:""
        fill_in :password, with:""
        click_button
        response.should have_selector("div.flash.error", content:"Invalid")
      end
    end

    describe "success" do

      it "should sign in" do
        user = FactoryGirl.create(:user)
        visit '/'
        integration_sign_in(user)
        #controller.should be_signed_in
        response.should have_selector("td.sidebar.round", content: user.name)
        response.should have_selector("a", href: user_path(user))
        click_link "Sign out"
        response.should have_selector("a", href:'/signin')
        #controller.should_not be_signed_in
      end
    end

  end






end