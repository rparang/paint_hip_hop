# == Schema Information
#
# Table name: votes
#
#  id         :integer         not null, primary key
#  video_id   :integer
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Vote < ActiveRecord::Base
	belongs_to :video, :counter_cache => true
	belongs_to :user

	validates :user_id, :presence => true

end
