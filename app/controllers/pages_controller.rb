class PagesController < ApplicationController
  
  def home
  	if signed_in?
  		@feed_items = current_user.feed

    else
      @feed_items = Video.all

  	end
  	#@videos = Video.all
    @vote = Vote.new
  end

  def user
  end
  
  def video
  end

end
