class CreateFaqs < ActiveRecord::Migration

  def self.up
    create_table :faqs do |t|
      t.string :title
      t.text :description
      t.string :tag
      t.integer :position

      t.timestamps
    end

    add_index :faqs, :id

    User.find(:all).each do |user|
      user.plugins.create(:title => "Faqs", :position => (user.plugins.maximum(:position) || -1) +1)
    end

    page = Page.create(
      :title => "Faqs",
      :link_url => "/faqs",
      :deletable => false,
      :position => ((Page.maximum(:position, :conditions => "parent_id IS NULL") || -1)+1),
      :menu_match => "^/faqs(\/|\/.+?|)$"
    )
    RefinerySetting.find_or_set(:default_page_parts, ["Body", "Side Body"]).each do |default_page_part|
      page.parts.create(:title => default_page_part, :body => nil)
    end
  end

  def self.down
    UserPlugin.destroy_all({:title => "Faqs"})

    Page.find_all_by_link_url("/faqs").each do |page|
      page.link_url, page.menu_match = nil
      page.deletable = true
      page.destroy
    end
    Page.destroy_all({:link_url => "/faqs"})

    drop_table :faqs
  end

end
