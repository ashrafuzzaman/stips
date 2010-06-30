class CreatePolls < ActiveRecord::Migration

  def self.up
    create_table :polls do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.integer :position

      t.timestamps
    end

    add_index :polls, :id

    User.find(:all).each do |user|
      user.plugins.create(:title => "Polls", :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end

  def self.down
    UserPlugin.destroy_all({:title => "Polls"})
    drop_table :polls
  end

end
