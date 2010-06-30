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

    page = Page.create(
      :title => "Polls",
      :link_url => "/polls",
      :deletable => false,
      :position => ((Page.maximum(:position, :conditions => "parent_id IS NULL") || -1)+1),
      :menu_match => "^/polls(\/|\/.+?|)$"
    )
    RefinerySetting.find_or_set(:default_page_parts, ["Body", "Side Body"]).each do |default_page_part|
      page.parts.create(:title => default_page_part, :body => nil)
    end
  end

  def self.down
    UserPlugin.destroy_all({:title => "Polls"})

    Page.find_all_by_link_url("/polls").each do |page|
      page.link_url, page.menu_match = nil
      page.deletable = true
      page.destroy
    end
    Page.destroy_all({:link_url => "/polls"})

    drop_table :polls
  end

end
