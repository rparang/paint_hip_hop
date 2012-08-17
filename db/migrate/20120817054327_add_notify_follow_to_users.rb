class AddNotifyFollowToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_follow, 			:boolean, :default => true
    add_column :users, :notify_comment,			:boolean, :default => true
    add_column :users, :notify_post_available, 	:boolean, :default => true
  end
end
