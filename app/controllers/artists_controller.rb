class ArtistsController < ApplicationController
  def index
  	@artists = Artist.all
    @artists = Artist.order_by('name ASC')#.collect {|x| [x.name, x.id] }
  end

  def show
  	@artist = Artist.find(params[:id])
  	@videos = @artist.videos
    @feed_items = @artist.videos
    @comment = Comment.new
  end

  def destroy
  	Artist.find(params[:id]).destroy
    flash[:success] = "Artist was deleted. #{ActionController::Base.helpers.link_to "Close", '#'}".html_safe
    redirect_to artists_path
  end
end
