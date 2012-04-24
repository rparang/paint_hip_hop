class VideosController < ApplicationController
 
  def search
    @yt_client = YouTubeIt::Client.new
    query = params[:s]
    @vids =  @yt_client.videos_by(:query => "#{query}")
    @video_titles = @vids.videos.collect {|v| v.title}
    @video_image_url = @vids.videos.collect {|v| v.thumbnails}
    @video_url = @vids.videos.collect {|v| v.player_url}
    @video_id = @vids.videos.collect {|v| v.video_id }
  end
 
  def index
    @videos = Video.all
  end

  def video
  end

  def show
  end

  def edit
  end

  def destroy
  end

  def create
      @video = Video.new(params[:video], :youtube_id => "3fumBcKC6RE")
      @video.save!
      redirect_to @video
  end
  
  def update
  end

  def new
    @yt_client = YouTubeIt::Client.new
    query = params[:v]
    @vids =  @yt_client.video_by("#{query}")
    @video_image_url = @vids.thumbnails
    
    @video = Video.new
  
    
  end
end
