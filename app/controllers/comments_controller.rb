class CommentsController < ApplicationController
  respond_to :html, :xml, :json

  def new
	@comment = Comment.new(params[:id])
  end

  def create
	@comment = current_user.comments.build(params[:comment])
	@video = Video.find(params[:comment][:video_id])
	if @comment.save
	  UserMailer.delay.video_comment_email(@video, current_user, @comment) if @video.user.notify_comment == true
	  respond_with do |format|
	    format.html do
		  if request.xhr?
		    render :json => {:comment => @comment, :comment_count => @video.comments.count, :path => user_path(@comment.user), :name => @comment.user.username, :image => @comment.user.image, :video_id => @video.id}
		  end
		end
	  end
	else
	  flash[:error] = "Something went wrong with your comment. We're looking into it."
	  respond_to do |format|
		format.html { redirect_to :back }
		format.js
	  end
	end
  end

  def destroy
  	@comment = Comment.find(params[:id])
  	@comment.destroy
    respond_with do |format|
      format.html do
      	if request.xhr?
      	  render :json => {:comment => @comment} #Send object back to identify ID to hide on front-end
      	end
      end
  	end
	#flash[:success] = "Your comment was deleted. No one will ever know."
  end

end