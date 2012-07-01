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
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :username, :bio, :password, :password_confirmation
  has_secure_password

  has_many :videos, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                    :class_name => "Relationship",
                                    :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed         #User that you follow
  has_many :followers, :through => :reverse_relationships, :source => :follower #Users that follow you
  has_many :votes
  has_many :comments, :dependent => :destroy

  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  before_save :create_bio
  after_create :initial_follow
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  #validates :first_name, :presence => true, :length => { maximum: 50 }
                         
  #validates :last_name, :presence => true, :length => { maximum: 50 }

  validates :username, :presence => true, :length => { maximum: 50 }
  
  validates :email, :presence => true, 
                   :format => { with: VALID_EMAIL_REGEX }, 
                   :uniqueness => { case_sensitive: false }
                    
  validates :password, :length => { minimum: 6 }
  validates :password_confirmation, :presence => true

  #default_scope order: 'users.created_at ASC'
  scope :users_created_at_ascending, :order => 'users.created_at ASC'

  def feed
    Video.from_users_following(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(:followed_id => other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def points
    points_array = self.videos.collect { |v| v.votes_count }
    total_points = points_array.inject(:+)
    return total_points
  end

  def vote?(video_id)
    self.votes.find_by_video_id(video_id)
  end

  def current_video
    self.videos.first
  end
  


  private
  
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def create_bio
      if self.bio.nil?
        self.bio = "Just a young buck on the town..."
      end
    end

    def initial_follow
      first_user = User.first
      self.follow!(first_user)
    end
  
end
