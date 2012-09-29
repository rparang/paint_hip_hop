class RemoveSocialUrlFromAuthentications < ActiveRecord::Migration
  def up
    remove_column :authentications, :social_url
    remove_column :authentications, :social_image
  end

  def down
    add_column :authentications, :social_image, :string
    add_column :authentications, :social_url, :string
  end
end
