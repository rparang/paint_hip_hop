Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "mGKghdOaqTRf2egWB0X7A", "mAM3AESsqjvxkSfmRD0JAT0HWby4zlvS3Y3ZtBLqXI"
  provider :facebook, "235617383228391", "9a34bd7b3ae8a4727f705b34c16378f6",
  	:scope => 'email', :display => 'popup'
end