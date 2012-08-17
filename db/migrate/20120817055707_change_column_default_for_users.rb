class ChangeColumnDefaultForUsers < ActiveRecord::Migration
  def up
  	change_column_default(:users, :notify_follow, :true)
  	change_column_default(:users, :notify_comment, :true)
  	change_column_default(:users, :notify_post_available, :true)
  end

  def down
  	change_column_default(:users, :notify_follow, :false)
  	change_column_default(:users, :notify_comment, :false)
  	change_column_default(:users, :notify_post_available, :false)
  end
end
