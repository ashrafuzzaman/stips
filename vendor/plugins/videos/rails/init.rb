Refinery::Plugin.register do |plugin|
  plugin.title = "Videos"
  plugin.description = "Manage Videos"
  plugin.version = 1.0
  plugin.activity = {
    :class => Video,
    :url_prefix => "edit",
    :title => 'title'
  }
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
