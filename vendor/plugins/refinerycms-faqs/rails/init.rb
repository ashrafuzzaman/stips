Refinery::Plugin.register do |plugin|
  plugin.title = "Faqs"
  plugin.description = "Manage Faqs"
  plugin.version = 1.0
  plugin.activity = {
    :class => Faq,
    :url_prefix => "edit",
    :title => 'title'
  }
end
