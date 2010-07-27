User.find(:all).each do |user|
  user.plugins.create(:title => "Videos", :position => (user.plugins.maximum(:position) || -1) +1)
end

page = Page.create(
  :title => "Videos",
  :link_url => "/videos",
  :deletable => false,
  :position => ((Page.maximum(:position, :conditions => "parent_id IS NULL") || -1)+1),
  :menu_match => "^/videos(\/|\/.+?|)$"
)
RefinerySetting.find_or_set(:default_page_parts, ["Body", "Side Body"]).each do |default_page_part|
  page.parts.create(:title => default_page_part, :body => nil)
end
