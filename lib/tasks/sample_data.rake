namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		make_users
		make_videos
		make_relationships
	end
end

def make_users
	admin = User.create!(:username => "shotcalla23",
						 :email => "reza@parang.com", :password => "password",
						 :password_confirmation => "password")
	admin.toggle!(:admin)
	20.times do |n|
		n += 1
		username_raw = Faker::Name.name + (10*rand()).to_i.to_s
		username = username_raw.gsub(/\s+/, "")
		#first_name = Faker::Name.first_name
		#last_name = Faker::Name.last_name
		email = "myemail-#{n}@paintthetownapp.com"
		password = "password"
		password_confirmation = "password"
		User.create!(:username => username, :email => email,
					 :password => password, :password_confirmation => password_confirmation)
	end
end


def make_videos
	users = User.all
	yt_client = YouTubeIt::Client.new
	5.times do |n|
		#random_name = Faker::Name.name

		users.each do |user|
			
			rap_name = ["Lil Boosie", "Webbie", "Ludacris", "Travis Porter", "Drake", "Tupac", "Nate Dogg", "DJ Quik", "Beastie Boys", "Q-Tip"]
			random_number = (10*rand()).to_i
			vids = yt_client.videos_by(:query => rap_name[random_number], :page => 1, :per_page => 1)
			vids_trim = vids.videos
			title = vids_trim[0].title
			youtube_id = vids_trim[0].video_id.split(":").last
			description = vids_trim[0].description
			duration = vids_trim[0].duration
			youtube_view_count = vids_trim[0].view_count

			user.videos.create!(:title => title, :youtube_id => youtube_id, :youtube_id => youtube_id, :description => description, :duration => duration, :youtube_view_count => youtube_view_count)
		end
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




