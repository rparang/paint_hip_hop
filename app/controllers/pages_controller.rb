class PagesController < ApplicationController
  
  def home
  	if signed_in?
  		@feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 10)
    else
      @feed_items = Video.paginate(:page => params[:page], :per_page => 10)
  	end
  	#@videos = Video.all
    @vote = Vote.new
  end

  def user
  end
  
  def video
  end

end
