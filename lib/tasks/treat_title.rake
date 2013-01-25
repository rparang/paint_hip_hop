namespace :db do
	desc "Treat and extract artist name from title field"
	task :extract_artist_name => :environment do
		extract_artist
	end
end

def extract_artist
	videos = Video.all
	#videos = videos[0..1]
	videos.each do |v|
		title = v.title
		string_array = title.split(/[-]+/)
		if string_array.length == 2
			create_artist(v, string_array[0])
			update_title(v, string_array[1])
		end
	end
end

def create_artist(video, artist_name)
	artist = artist_name.titleize.gsub(/\[.*\]/, "").gsub(/\(.*\)/, "").gsub(/"/, '').strip
	artist_lookup = Artist.find_by_name(artist)
	if artist_lookup
		video.update_attribute(:artist_id, artist_lookup.id)
	else
		Artist.create_new_artist(artist)
		artist_lookup = Artist.find_by_name(artist)
		video.update_attribute(:artist_id, artist_lookup.id)
	end
end

def update_title(video, track_title)
	new_track_title = track_title.titleize.gsub(/\[.*\]/, "").gsub(/\(.*\)/, "").gsub(/"/, '').strip
	video.update_attribute(:title, new_track_title)
end
