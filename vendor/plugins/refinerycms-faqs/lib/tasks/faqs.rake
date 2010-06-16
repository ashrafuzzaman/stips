namespace :refinery do
  namespace :faqs do
	  desc "Install extra files from the faqs plugin"

  	task :install do
  		puts `ruby #{File.expand_path(File.dirname(__FILE__) << '/../..')}/bin/refinerycms-faqs-install #{Rails.root.to_s}`
  	end
	end
end