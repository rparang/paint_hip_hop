class RemoveVoteCountFromVideos < ActiveRecord::Migration
  def up
    remove_column :videos, :votes_count
  end

  def down
    add_column :videos, :votes_count, :integer
  end
end
