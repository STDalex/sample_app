class MicropostsController < ApplicationController
  before_filter :authenticate, only: [:index, :create, :destroy]
  before_filter :find_micropost, only: :destroy

  def index
    @user = User.find(params[:user_id])
    @title = "#{@user.name} microposts"
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost  '#{@micropost.content}' destroyed!"
    redirect_back_or root_path
  end

  private

    def find_micropost
      @micropost ||= current_user.microposts.find_by_id(params[:id])
    end
end