# Try to include the rails initializer. If this isn't in a gem, this will fail.
if Refinery.is_a_gem
  begin
    require 'initializer'
  rescue LoadError => load_error
    # we don't need to do anything.
    puts "*** RefineryCMS gem load failed, attempting to load traditionally... ***"
  end
end

module Refinery

  class Configuration < Rails::Configuration
    def default_plugin_paths
      paths = super.push(Refinery.root.join("vendor", "plugins").to_s).uniq
    end
  end

  class PluginLoader < Rails::Plugin::Loader
    def add_plugin_load_paths
      # call Rails' add_plugin_load_paths
      super

      # add plugin lib paths to the $LOAD_PATH so that rake tasks etc. can be run when using a gem for refinery or gems for plugins.
      search_for = Regexp.new(Refinery.root.join("vendor", "plugins", ".+?", "lib").to_s)

      # find all the plugin paths
      paths = plugins.collect{ |plugin| plugin.load_paths }.flatten

      # just use lib paths from Refinery engines
      paths = paths.reject{|path| path.scan(search_for).empty? or path.include?('/rails-') }

      # reject Refinery lib paths if they're already included in this app.
      paths = paths.reject{ |path| path.include?(Refinery.root.to_s) } unless Refinery.is_a_gem
      paths.uniq!

      ($refinery_gem_plugin_lib_paths = paths).each do |path|
        $LOAD_PATH.unshift path
      end
      $LOAD_PATH.uniq!
    end
  end

  class Initializer < Rails::Initializer
    def self.run(command = :process, configuration = Configuration.new)
      # Set up configuration that is rather specific to Refinery. (some plugins require on other more 'core' plugins).
      # We do make sure we check that things haven't already been set in the application.
      configuration.plugin_loader = Refinery::PluginLoader unless configuration.plugin_loader != Rails::Plugin::Loader
      configuration.plugins = [ :acts_as_indexed, :authlogic, :friendly_id, :all ] if configuration.plugins.nil?

      # Pass our configuration along to Rails.
      Rails.configuration = configuration

      # call Rails' run
      super

      # Prevent page slugs from using any routes used by registered engines. (Needs updating for Rails3)
      if defined?(Page)
        # First we need to find out all of the routes in use by this application.
        reserved_routes = ActionController::Routing::Routes.routes.collect do |route|
          route.segments.inject("") {|str, segment| str << segment.to_s.gsub(/\(\.:format\)\?/, '') }
        end

        # Now we need just the first part of the routing segment.
        reserved_routes = reserved_routes.collect { |segment| segment.gsub(/^\//, '').split('/').first}.compact.uniq.reject {|r| r =~ /^:/ }

        # Now append all of the routes to the reserved words list and ensure they're all unique.
        (Page.friendly_id_config.reserved_words += reserved_routes).uniq!
      end

      # Create deprecations for variables that we've stopped using (possibly remove in 1.0?)
      require 'refinery/deprecations'
    end
  end

end
