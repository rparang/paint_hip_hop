ActionMailer::Base.smtp_settings = {
  :address				=> "smtp.gmail.com",
  :port					=> 587,
  :domain				=> "paintthetownapp.com",
  :user_name			=> "paintthetownapp",
  :password				=> "Decemb23",
  :authentication		=> "plain",
  :enable_starttls_auto => true
}