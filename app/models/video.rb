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
  attr_accessible :title, :user_id, :youtube_id, :description, :duration, :youtube_view_count
  
  belongs_to :user
  has_many :votes, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  validates :user_id, :presence => true

  #default_scope order: 'videos.created_at DESC'
  scope :videos_created_at_descending, order: 'videos.created_at DESC'
  scope :videos_votes_count_descending, order: 'videos.votes_count DESC'
  

  def self.from_users_following(user) #Note: tutorial takes this further for scale
  	following_ids = (user.following_ids << user.id).join(', ')
  	where("user_id IN (#{following_ids})")
  end


end
