class VotesController < ApplicationController

	def new
		@vote = Vote.new
	end


	def create
		@vote = current_user.votes.build(params[:vote])
		
		params.each do |key,value|
  			Rails.logger.warn "Param #{key}: #{value}"
		end

		if @vote.save
			@video = Video.find(params[:vote][:video_id])
			flash[:success] = "Your vote went through mofugga"
			respond_to do |format|
				format.html { redirect_to :back }
				format.js
			end

		else
			flash[:error] = "Some shit is wrong with your vote"
			respond_to do |format|
				format.html { redirect_to :back }
				format.js
			end
		end
	end

end