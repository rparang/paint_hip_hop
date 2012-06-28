class PagesController < ApplicationController
  
  def home
    @vote = Vote.new
  	if signed_in?
  		@feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 10)
      if request.xhr?
        sleep(2) # make request a little bit slower to see loader :-)
        render :partial => 'shared/feed'
      end
    else
      @feed_items = Video.paginate(:page => params[:page], :per_page => 10)
      if request.xhr?
        #sleep(3) # make request a little bit slower to see loader :-)
        render :partial => 'shared/feed'
      end
  	end
  	#@videos = Video.all
  end

  def user
  end
  
  def video
  end

end
