class UserMailer < ActionMailer::Base
  default from: "notifications@paintthetownapp.com"

  def welcome_email(user)
    @user = user
	@url  = "http://localhost:3000/siginin"
	mail(:to => user.email, :subject => "Welcome to Paint the Town")
  end

end
