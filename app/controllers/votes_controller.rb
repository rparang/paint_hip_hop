class VotesController < ApplicationController
  @vote = Vote.new
  respond_to :html, :xml, :json

  def new
		@vote = Vote.new
  end

  def create
    @vote = current_user.votes.build(params[:vote])
	  #params.each do |key,value|
  	  #	 Rails.logger.warn "Param #{key}: #{value}"
	  #end

	if @vote.save
	  @video = Video.find(params[:vote][:video_id])
	  respond_with do |format|
	    format.html do
		  if request.xhr?
		    render :json => {:vote_count => @video.votes.count,
												 :name => @vote.user.username,
												 :image => @vote.user.image,
												 :path => user_path(@vote.user),
												 :video_id => @video.id
												}
		  end
		end
	  end
	else
	  respond_with do |format|
	    format.html do
		  if request.xhr?
		    render :text => "Error!" #Not surfacing text
		  end
		end
	  end
	end
  end

  def destroy
  	@vote = Vote.new
  	@video = Video.find(Vote.find(params[:id]).video_id)
  	Vote.find(params[:id]).destroy
  	respond_to do |format|
	  format.html { redirect_to :back }
	  format.js
	end
  end

end