class UsersController < ApplicationController
  before_filter :signed_in_user, :only => [:edit, :update]
  before_filter :correct_user,   :only => [:edit, :update]
  before_filter :admin_user,     :only => :destroy
  respond_to :html, :xml, :json
  
  def show
    @user = User.find(params[:id])
    @videos = @user.videos
    @feed_items = @user.videos
    @vote = Vote.new
    @comment = Comment.new(params[:vote])
  end
  
  def new
    @user = User.new
    @black_page = true
    if @omniauth = session[:omniauth]
      @user_image = @omniauth.info.image
      @nickname = @omniauth.info.name
      @email = @omniauth.info.email
    end
  end
  
  def create
    @user = User.new(params[:user])
    omniauth = session[:omniauth]
    if omniauth
      @user.apply_omniauth(omniauth)
    end
    if @user.save
      #UserMailer.welcome_email(@user).deliver
      session[:omniauth] = nil
      sign_in @user
      flash[:success] = "Welcome to Paint the Town! Let's have a toast."
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @authentications = User.find(params[:id]).authentications
  end
  
  def index
    @users = User.all
    respond_with do |format|
      format.html do
        if request.xhr?
          render :partial => 'shared/users', :layout => false
        end
      end
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Your profile was successfully updated. Proceed, young one."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "That account was destroyed. Tell no one."
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  private
  
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
end
