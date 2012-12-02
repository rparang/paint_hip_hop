class VideosController < ApplicationController
  before_filter :signed_in_user, :only => [:create, :destroy]
  include VideoHelper
  respond_to :html, :xml, :json
 
  def search
    #Sup
  end

  #Pulled out common variables and partial rendering for top song methods
  #----------------------------------------------------------------------
  def top_songs_common
    @vote = Vote.new(params[:vote])
    @comment = Comment.new(params[:vote])
    respond_with do |format|
      format.html do
        if request.xhr?
          render :partial => 'shared/feed', :layout => false#, :locals => { :path => @path }
        else
          render 'sort' unless params[:page] != nil
        end
      end
    end
  end

  def index
    @feed_items = Video.paginate(:page => params[:page], :per_page => 10)
    @path = videos_path
    @header_title = "Hits"
    top_songs_common
  end

  def top_day
    @feed_items = Video.top_day_videos.paginate(:page => params[:page], :per_page => 10)
    top_songs_common
  end

  def top_week
    @feed_items = Video.top_week_videos.paginate(:page => params[:page], :per_page => 50)
    top_songs_common
  end

  def top_month
    @feed_items = Video.top_month_videos.paginate(:page => params[:page], :per_page => 10)
    top_songs_common
  end

  def top_alltime
    @feed_items = Video.top_alltime_videos.paginate(:page => params[:page], :per_page => 50)
    top_songs_common
  end

 #End top song methods
 #----------------------------------------------------------------------


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
    if @video.save
      flash[:success] = "Your Video is now live"
      facebook_share(params[:video], @video) #If the user has selected the checkbox to share on Facebook
      twitter_share(params[:video])          #If the user has selected the checkbox to share on Twitter
      redirect_to @video
    else
      flash[:error] = "Something went wrong with your video. We're looking into it."
      redirect_to root_path
    end
  end

  def twitter_share(params)
    if params[:share_twitter] == "1"
        begin
          token = current_user.authentications.where(:provider => "twitter")[0].token
          secret = current_user.authentications.where(:provider => "twitter")[0].secret
          message = "#{params[:title]} on @thepaintapp:" + " #{request.protocol}#{request.host_with_port}#{request.fullpath}/#{@video.id}" 
          current_user.share_video_twitter(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, token, secret, message)
        rescue
          flash[:error] = "There was a problem sharing your video. We're looking into it."
        end
      end
  end

  def facebook_share(params, video)
    if params[:share_facebook] == "1"
        begin
          token = current_user.authentications.where(:provider => "facebook")[0].token
          message = ""
          title = video.title
          url_extension = "#{video.id} #{title}".parameterize
          url = "#{request.protocol}#{request.host_with_port}#{request.fullpath}/#{url_extension}"
          caption = MESSAGE
          description = video.description
          thumb_url = "http://i.ytimg.com/vi/#{video.youtube_id}/default.jpg"
          target = ""
          current_user.share_video_facebook(token, message, title, url, caption, description, thumb_url, target)
        rescue
          flash[:error] = "There was a problem sharing your video. We're looking into it."
        end
      end    
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