class CreateVideos < ActiveRecord::Migration

  def self.up
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.integer :position

      t.timestamps
    end

    add_index :videos, :id

    load(Rails.root.join('db', 'seeds', 'videos.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:title => "Videos"})

    Page.find_all_by_link_url("/videos").each do |page|
      page.link_url, page.menu_match = nil
      page.deletable = true
      page.destroy
    end
    Page.destroy_all({:link_url => "/videos"})

    drop_table :videos
  end

end
