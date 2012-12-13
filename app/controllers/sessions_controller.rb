class SessionsController < ApplicationController
  before_filter :allready_signed_in_user, only: :new 
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = 'Invalid email\password combination.'
      @title = "Sign in"
      render :new
    else
      sign_in user
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private 

  def allready_signed_in_user
    redirect_to(root_path) if signed_in?
  end

end
