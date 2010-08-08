# Load the rails application
require File.expand_path('../application', __FILE__)

Rails::Initializer.run do |config|
  config.action_mailer.delivery_method = :smtp
  ActionMailer::Base.server_settings = { :address => "mail.stips.se",
    :port => 25, :user_name => "no-reply",   :password => "stips01",
    :authentication => :plain }
end