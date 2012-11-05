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
end