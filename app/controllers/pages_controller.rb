class PagesController < ApplicationController
  
  def home
    @vote = Vote.new
  	if signed_in?
  		@feed_items = Video.paginate(:page => params[:page], :per_page => 10)
      if request.xhr?
        render :partial => 'shared/feed'
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
