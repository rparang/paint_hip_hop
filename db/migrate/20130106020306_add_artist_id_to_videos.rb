class AddArtistIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :artist_id, :integer
    add_column :videos, :soundcloud_url, :string
    add_column :videos, :featured_artists, :string
  end
end
