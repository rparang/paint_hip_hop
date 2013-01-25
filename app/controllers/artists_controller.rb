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
  	
  end
end
