namespace :refinery do
  namespace :poll do
	  desc "Install extra files from the poll plugin"

  	task :install do
  		puts `ruby #{File.expand_path(File.dirname(__FILE__) << '/../..')}/bin/refinerycms-poll-install #{Rails.root.to_s}`
  	end
	end
end