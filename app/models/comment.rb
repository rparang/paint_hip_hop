class Comment < ActiveRecord::Base
	#attr_accessible :video_id, :user_id, :content

	belongs_to :video
	belongs_to :user

	validates :user_id, :presence => true
	validates :content, :presence => true


end
