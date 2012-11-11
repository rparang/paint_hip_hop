class VideosController < ApplicationController
  before_filter :signed_in_user, :only => [:create, :destroy]
 
  def search
    @yt_client = YouTubeIt::Client.new
    query = params[:s]
    @vids =  @yt_client.videos_by(:query => "#{query}", :page => 1, :per_page => 10)
    @video_titles = @vids.videos.collect {|v| v.title} #User.first.followed_users.map(&:id) - consult Rails Tutorial 11.3.2
    @video_image_url = @vids.videos.collect {|v| v.thumbnails}
    @video_url = @vids.videos.collect {|v| v.player_url}
    @video_id = @vids.videos.collect {|v| v.video_id }
    @video_duration = @vids.videos.collect {|v| v.duration }
  end
 
  def index
    #@videos = Video.paginate(:page => params[:page], :per_page => 2)
    @vote = Vote.new(params[:vote])
    @feed_items = Video.desc_videos.paginate(:page => params[:page], :per_page => 10)
    #@feed_items = Video.paginate(:page => params[:page], :per_page => 10)
    if request.xhr?
      render :partial => 'shared/feed'
    end
  end

  def show
    @video = Video.find(params[:id])
    @user_videos = Video.find(params[:id]).user.videos.limit(10)
    @vote = Vote.new(params[:vote])
    @comment = Comment.new(params[:vote])
    @comment_items = @video.comments
  end


  def new
    @yt_client = YouTubeIt::Client.new
    query = params[:v]
    @vid =  @yt_client.video_by("#{query}")
    @video_image_url = @vid.thumbnails
    @video = Video.new
    @comment = Comment.new
  end

  def create
    @video = current_user.videos.build(params[:video])
    #logger.debug "share_facebook is #{params[:video]}"
            #time_now = Time.now.localtime
            #@last_video_created_time = current_user.videos.first.created_at
            #if (time_now - @last_video_created_time) >= 84600
    if @video.save
      flash[:success] = "Your Video is now live"
      #If the user has selected the checkbox to share on Facebook
      if params[:video][:share_facebook] == "1"
        begin
          token = current_user.authentications.where(:provider => "facebook")[0].token
          message = ""
          title = @video.title
          url_extension = "#{@video.id} #{title}".parameterize
          url = "#{request.protocol}#{request.host_with_port}#{request.fullpath}/#{url_extension}"
          caption = MESSAGE
          description = @video.description
          thumb_url = "http://i.ytimg.com/vi/#{@video.youtube_id}/default.jpg"
          target = ""
          current_user.share_video_facebook(token, message, title, url, caption, description, thumb_url, target)
        rescue
          flash[:error] = "There was a problem sharing your video. We're looking into it."
        end
      end    
      #If the user has selected the checkbox to share on Twitter
      if params[:video][:share_twitter] == "1"
        begin
          token = current_user.authentications.where(:provider => "twitter")[0].token
          secret = current_user.authentications.where(:provider => "twitter")[0].secret
          message = "#{params[:video][:title]} on @thepaintapp:" + " #{request.protocol}#{request.host_with_port}#{request.fullpath}/#{@video.id}" 
          current_user.share_video_twitter(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, token, secret, message)
        rescue
          flash[:error] = "There was a problem sharing your video. We're looking into it."
        end
      end
      redirect_to @video
    else
      flash[:error] = "Something went wrong with your video. We're looking into it."
      render '/pages/home'
    end
            #else
              #render :js =>  "alert('You may vote once every 24 hours for any one item.');"
            #end
  end

  def edit
    @video = Video.find(params[:id])
  end

  def update
    @video = Video.find(params[:id])
    if @video.update_attributes(params[:video])
      flash[:success] = "Your video was updated successfully!"
      redirect_to @video
    else
      render 'edit'
    end
  end

  def destroy
    Video.find(params[:id]).destroy
    flash[:success] = "Your video was deleted. Good riddance."
    redirect_to root_path
  end

end