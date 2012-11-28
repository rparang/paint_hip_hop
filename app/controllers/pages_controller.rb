class PagesController < ApplicationController
  
  def home
    @vote = Vote.new
    @comment = Comment.new(params[:vote])
  	if signed_in?
  		@feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 10)
      if request.xhr?
        render :partial => 'shared/feed'
        #sleep(6)
      end
    else
      @feed_items = Video.paginate(:page => params[:page], :per_page => 10)
      if request.xhr?
        render :partial => 'shared/feed'
      end
  	end
  end

  def about
  end

end
