Refinery::Plugin.register do |plugin|
  plugin.title = "Courses"
  plugin.description = "Manage Courses"
  plugin.version = 1.0
  plugin.activity = {
    :class => Course,
    :url_prefix => "edit",
    :title => 'title'
  }
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
