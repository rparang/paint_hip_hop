namespace :db do
	desc "Fill database with sample data"
	task :add => :environment do
		#make_songs
		make_votes
	end
end

def make_songs
	users = User.all
	yt_client = YouTubeIt::Client.new
	5.times do |n|
		#random_name = Faker::Name.name

		users.each do |user|
			
			rap_name = ["Run-D.M.C.","Public Enemy","2Pac","Eric B. & Rakim","Jay-Z","OutKast","N.W.A","Notorious B.I.G.","Grandmaster Flash & the Furious Five","A Tribe Called Quest","Nas","Ice Cube","LL Cool J","De La Soul","Kanye West","Scarface","Big Daddy Kane","Dr. Dre","Wu-Tang Clan","Eminem","UGK","Boogie Down Productions","The Beastie Boys","Slick Rick","EPMD","Snoop Dogg","MC Lyte","Gang Starr","Afrika Bambaataa","Kool G Rap","Kurtis Blow","The Roots","E-40","Common","The Jungle Brothers","Whodini","Ghostface Killah","Lauryn Hill","Eightball & MJG","Goodie MOB","Too $hort","Bone Thugs N Harmony","Mos Def","Salt N Pepa","Busta Rhymes","Digital Underground","Lil Wayne","Pete Rock & CL Smooth","The Fugees","DJ Jazzy Jeff & the Fresh Prince"]
			random_number = (rap_name.length*rand()).to_i
			vids = yt_client.videos_by(:query => rap_name[random_number], :page => 1, :per_page => 1)
			vids_trim = vids.videos
			title = vids_trim[0].title
			youtube_id = vids_trim[0].video_id.split(":").last
			description = vids_trim[0].description
			duration = vids_trim[0].duration

			user.videos.create!(:title => title, :youtube_id => youtube_id, :description => description, :duration => duration)
		end
	end
end

def make_votes
	users = User.all
	videos = Video.all
	vid_ids = videos.collect { |c| c.id }

	50.times do |n|
		users.each do |u|
			random_id = (vid_ids.length*rand()).to_i
			rand_vid = vid_ids[random_id]
			u.votes.create!(:video_id => rand_vid)
		end	
	end
end