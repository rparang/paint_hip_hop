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
  attr_accessible :first_name, :last_name, :email, :username, :bio, :password, :password_confirmation, :notify_follow, :notify_comment, :notify_post_available

  has_many :videos, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                    :class_name => "Relationship",
                                    :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed         #User that you follow
  has_many :followers, :through => :reverse_relationships, :source => :follower #Users that follow you
  has_many :votes
  has_many :comments, :dependent => :destroy
  has_many :authentications, :dependent => :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  before_save :create_bio
  after_create :initial_follow
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :username, :presence => true, :length => { maximum: 50 }, :uniqueness => { case_sensitive: false }
  
  validates :email, :presence => true, 
                   :format => { with: VALID_EMAIL_REGEX }, 
                   :uniqueness => { case_sensitive: false }

  default_scope order: 'users.created_at ASC'

  has_secure_password

  validates_presence_of :password, :on => :create, :if => :password_required

  before_validation :no_password_omniauth

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

  def image
    count = authentications.count
    if count == 0
      user_image = nil
    elsif count == 1
      user_image = authentications[0].social_image
    elsif count == 2 && authentications[0].provider == 'facebook'
      user_image = authentications[0].social_image
    else
      user_image = authentications[1].social_image
    end
    return user_image
  end

  def has_facebook?
    authentications.where(:provider => "facebook")
  end

  def has_twitter?
    authentications.where(:provider => "twitter")
  end

  @called_omniauth = false

  def apply_omniauth(omniauth)
    omniauth['info']['urls']['Twitter'] ? omniauth_social_url = omniauth['info']['urls']['Twitter'] : omniauth_social_url = omniauth['info']['urls']['Facebook']
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], 
                          :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret'],
                          :token_expiration => omniauth['credentials']['expires_at'], :social_url => omniauth_social_url,
                          :social_image => omniauth['info']['image'])
    self.email = omniauth['info']['email'] if email.blank?
    self.first_name = omniauth['info']['first_name'] if first_name.blank?
    self.last_name = omniauth['info']['last_name'] if last_name.blank?
    @called_omniauth = true
  end

  def password_required
    return false if @called_omniauth == true
    (authentications.empty? || !password.blank?)
  end

  private
  
    def no_password_omniauth
      self.password_digest = 0 unless password_required
    end

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
