class ArtistsController < ApplicationController
  def index
  	@artists = Artist.all
  end

  def show
  	@artist = Artist.find(params[:id])
  	@videos = @artist.videos
    @feed_items = @artist.videos
    @comment = Comment.new
  end

  def destroy
  	
  end
end
