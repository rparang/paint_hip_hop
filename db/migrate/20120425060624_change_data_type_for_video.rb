class ChangeDataTypeForVideo < ActiveRecord::Migration
  def up
    change_table :videos do |t|
      t.change :youtube_id, :string
    end
  end

  def down
    change_table :videos do |t|
      t.change :youtube_id, :integer
    end
  end
end
