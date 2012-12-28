class SessionsController < ApplicationController
  
  def new
    @black_page = true
  end
  
  def create
    user = User.find_by_email(params[:session][:email])
    #user.new_user_session(user)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
    else
      flash[:message] = "Your email or password is incorrect. Please try again."
      redirect_to signin_path
    end
  end
    
  def destroy
    sign_out
    redirect_to root_path
  end

end
