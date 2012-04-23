class PagesController < ApplicationController
  
  def home 
  end

  def user
    @yt_client = YouTubeIt::Client.new
    query = params[:s]
    @vids =  @yt_client.videos_by(:query => "#{query}")
    @video_titles = @vids.videos.collect {|v| v.title}
    @video_image_url = @vids.videos.collect {|v| v.thumbnails}
    @video_url = @vids.videos.collect {|v| v.player_url}
    @video_id = @vids.videos.collect {|v| v.video_id }
  end
  
  def video
    @yt_client = YouTubeIt::Client.new
    query = params[:v]
    @vids =  @yt_client.video_by("#{query}")
    @video_image_url = @vids.thumbnails
  end
  
end
