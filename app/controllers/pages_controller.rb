class PagesController < ApplicationController
  def home
    
    
  end

  def user
    @yt_client = YouTubeIt::Client.new
    query = params[:s]
    @vids =  @yt_client.videos_by(:query => query)
    @video_titles = @vids.videos.collect {|v| v.title}
    @video_image_url = @vids.videos.collect {|v| v.thumbnails}
    @video_url = @vids.videos.collect {|v| v.player_url}
  end
end
