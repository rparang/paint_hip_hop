# == Schema Information
#
# Table name: videos
#
#  id                 :integer         not null, primary key
#  title              :string(255)
#  user_id            :integer
#  youtube_id         :string(255)
#  description        :text
#  duration           :integer
#  youtube_view_count :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
