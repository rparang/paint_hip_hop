class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  TWITTER_CONSUMER_KEY = "mGKghdOaqTRf2egWB0X7A"
  TWITTER_CONSUMER_SECRET = "mAM3AESsqjvxkSfmRD0JAT0HWby4zlvS3Y3ZtBLqXI"

  MESSAGE = "I just posted a new video on Paint the Town "

end
