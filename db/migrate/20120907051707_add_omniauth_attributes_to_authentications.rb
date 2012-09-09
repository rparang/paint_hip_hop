class AddOmniauthAttributesToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :token, :string
    add_column :authentications, :secret, :string
    add_column :authentications, :token_expiration, :integer
    add_column :authentications, :social_url, :string
    add_column :authentications, :social_image, :string
  end
end
