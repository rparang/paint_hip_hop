class AuthenticationsController < ApplicationController
  def index
  	@authentications = current_user.authentications if current_user
  end

  def create
  	omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      #Need to check to see if token, secret, social_url, social_image has changed. consider dropping social_url and social image
      sign_in(authentication.user)
      flash[:success] = "Signed in successfully"
      redirect_to root_path
    elsif current_user
      omniauth['info']['urls']['Twitter'] ? omniauth_social_url = omniauth['info']['urls']['Twitter'] : omniauth_social_url = omniauth['info']['urls']['Facebook']
    	current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], 
                                           :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret'],
                                           :token_expiration => omniauth['credentials']['expires_at'])
    	flash[:success] = "Authentication successful"
    	redirect_to root_path
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        sign_in(user)
        flash[:success] = "Signed in successfully"
        redirect_to authentications_path
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to signup_path
      end
    end
  end

  def destroy
  	@authentication = current_user.authentications.find(params[:id])
  	@authentication.destroy
  	flash[:success] = "Your authentication was successfully removed."
  	redirect_to :back
  end
end
