Refinery::Plugin.register do |plugin|
  plugin.title = "Courses Registration"
  plugin.description = "Manage Courses Registration"
  plugin.version = 1.0
  plugin.activity = {
    :class => CoursesUser,
    :url_prefix => "edit",
    :title => 'amount_paid'
  }
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
