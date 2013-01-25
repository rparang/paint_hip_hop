class Artist < ActiveRecord::Base
	attr_accessible :name, :bio, :image

	has_many :videos, :foreign_key => 'artist_id'

	def to_param
    "#{id} #{name}".parameterize
  end

	def self.create_new_artist(name)
		create(:name => name)
	end


end
