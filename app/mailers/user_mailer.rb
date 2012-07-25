class UserMailer < ActionMailer::Base
  default from: "Paint the Town <notifications@paintthetownapp.com>"
  default content_type: 'text/html'

  def welcome_email(user)
    @user = user
  	@url  = "http://localhost:3000/signin"
  	mail(:to => user.email, :from => "Paint the Town", :subject => "Welcome to Paint the Town")
  end

  def video_comment_email(video, commenting_user, comment)
  	@user = video.user
  	@commenting_user = commenting_user
  	@comment = comment
  	mail(:to => video.user.email, :from => "Paint the Town", :subject => "#{@commenting_user.username} commented on your video")
  end

  def follow_email (user, follower_user)
    @user = user
    @follower_user = follower_user
    mail(:to => user.email, :from => "Paint the Town", :subject => "#{@follower_user.username} is now following you!")
  end
  
end
