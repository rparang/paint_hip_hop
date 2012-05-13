class CommentsController < ApplicationController

	
	def new
		@comment = Comment.new(params[:id])
	end


	def create
		@comment = current_user.comments.build(params[:comment])

		if @comment.save
			flash[:success] = "Comment saved!"
			respond_to do |format|
				format.html { redirect_to :back }
				format.js
			end
		else
			flash[:error] = "Some shit is wrong with your comment"
			respond_to do |format|
				format.html { redirect_to :back }
				format.js
			end
		end
	end


	def destroy

	end




end