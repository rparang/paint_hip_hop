# == Schema Information
#
# Table name: videos
#
#  id                 :integer         not null, primary key
#  title              :string(255)
#  user_id            :integer
#  youtube_id         :string(255)
#  description        :text
#  duration           :integer
#  youtube_view_count :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  votes_count        :integerVi
#

class Video < ActiveRecord::Base
  attr_accessible :title, :user_id, :youtube_id, :description, :duration, :youtube_view_count, :share_facebook, :share_twitter
  attr_accessor :share_facebook, :share_twitter
  
  belongs_to :user
  has_many :votes, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  validates :user_id, :presence => true, :length => { maximum: 255 }
  validates :title, :presence => true

  default_scope order: 'videos.created_at DESC'
  #scope :videos_created_at_descending, order: 'videos.created_at DESC'
  #scope :videos_votes_count_descending, order: 'videos.votes_count DESC'
  
  def to_param
    "#{id} #{title}".parameterize
  end

  def self.from_users_following(user) #Note: tutorial takes this further for scale
  	#following_ids = (user.following_ids << user.id).join(', ')
  	#where("user_id IN (#{following_ids})")
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end

  def self.top_alltime_videos 
    self.unscoped.order("votes_count DESC")
  end

  def self.top_day_videos
    day_beg = DateTime.now.in_time_zone(Time.zone).beginning_of_day
    day_end = DateTime.now.in_time_zone(Time.zone).end_of_day
    self.unscoped.find(:all, :conditions => {:created_at => day_beg..day_end}, :order => "votes_count DESC")
  end

  def self.top_week_videos
    week_beg = DateTime.now.in_time_zone(Time.zone).beginning_of_week
    week_end = DateTime.now.in_time_zone(Time.zone).end_of_week
    self.unscoped.find(:all, :conditions => {:created_at => week_beg..week_end}, :order => "votes_count DESC")
  end

end
