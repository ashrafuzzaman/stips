Refinery::Plugin.register do |plugin|
  plugin.title = "Polls"
  plugin.description = "Manage Polls"
  plugin.version = 1.0
  plugin.activity = {
    :class => Poll,
    :url_prefix => "edit",
    :title => 'title'
  }
end
