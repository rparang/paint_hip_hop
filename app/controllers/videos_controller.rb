class VideosController < ApplicationController
  before_filter :signed_in_user, :only => [:create, :destroy]
 
  def search
    @yt_client = YouTubeIt::Client.new
    query = params[:s]
    @vids =  @yt_client.videos_by(:query => "#{query}", :page => 1, :per_page => 10)
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
    @video = Video.find(params[:id])
  end

  def edit
  end

  def destroy
  end

  def create
      @video = current_user.videos.build(params[:video])
      if @video.save
        flash[:succes] = "Video created biaatch"
        redirect_to @video
      else
        render '/pages/home'
      end
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