class VotesController < ApplicationController
  @vote = Vote.new
  

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
	  respond_to do |format|
		  format.html { redirect_to :back }
		  format.js
	  end

	else
	  flash[:error] = "Something is wrong with your vote"
	  respond_to do |format|
	      format.html { redirect_to :back }
	      format.js
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