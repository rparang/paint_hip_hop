class AddVotesToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :votes_count, :integer

  end
end
