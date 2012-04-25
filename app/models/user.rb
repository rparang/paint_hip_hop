# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation
  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :first_name, :presence => true, 
                         :length => { maximum: 50 }
                         
  validates :last_name, :presence => true, 
                        :length => { maximum: 50 }
  
  validates :email, :presence => true, 
                    :format => { with: VALID_EMAIL_REGEX }, 
                    :uniqueness => { case_sensitive: false }
                    
  validates :password, :length => { minimum: 6 }
  validates :password_confirmation, :presence => true
  
  
end
