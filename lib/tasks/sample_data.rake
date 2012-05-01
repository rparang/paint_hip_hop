namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		make_users
		make_videos
		make_relationships
	end
end

def make_users
	admin = User.create!(:first_name => "Reza", :last_name => "Parang",
						 :email => "reza@parang.com", :password => "password",
						 :password_confirmation => "password")
	admin.toggle!(:admin)
	20.times do |n|
		n += 1
		first_name = Faker::Name.first_name
		last_name = Faker::Name.last_name
		email = "myemail-#{n}@jams.com"
		password = "password"
		password_confirmation = "password"
		User.create!(:first_name => first_name, :last_name => last_name, :email => email,
					 :password => password, :password_confirmation => password_confirmation)
	end
end


def make_videos
	users = User.all
	yt_client = YouTubeIt::Client.new
	5.times do |n|
		#random_name = Faker::Name.name
		rap_name = ["Lil Boosie", "Webbie", "Ludacris", "Travis Porter", "Drake"]
		#include rand() function
		vids = yt_client.videos_by(:query => rap_name[n])
		vids_trim = vids.videos
		title = vids_trim[0].title
		youtube_id = vids_trim[0].video_id.split(":").last
		description = vids_trim[0].description
		duration = vids_trim[0].duration
		youtube_view_count = vids_trim[0].view_count

		users.each { |user| user.videos.create!(:title => title, :youtube_id => youtube_id, :youtube_id => youtube_id, :description => description, :duration => duration, :youtube_view_count => youtube_view_count)}
	end
end

def make_relationships
	users = User.all
	user = User.first
	followed_users = users[2..19]
	followers 	   = users[5..19]
	followed_users.each { |f| user.follow!(f) }
	followers.each 	    { |f| f.follow!(user) }
	followers.each 	    { |f| f.follow!(users[1]) }
	followers.each 	    { |f| f.follow!(users[2]) }
end




