ActionMailer::Base.smtp_settings = {
  :address				=> "smtp.gmail.com",
  :port					=> 587,
  :domain				=> "paintapp.co",
  :user_name			=> "paintthetownapp",
  :password				=> "hardinthepaint",
  :authentication		=> "plain",
  :enable_starttls_auto => true
}