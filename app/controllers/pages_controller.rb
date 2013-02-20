class PagesController < ApplicationController
	respond_to :html, :xml, :json

	def about
		#@videos = Video.from_users_following(current_user)
		#@video_ids = @videos.collect { |v| v.youtube_id}
	end

end