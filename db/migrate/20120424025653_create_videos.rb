class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.integer :user_id
      t.integer :youtube_id
      t.text :description
      t.integer :duration
      t.integer :youtube_view_count

      t.timestamps
    end
  end
end
