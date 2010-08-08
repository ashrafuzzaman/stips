# Load the rails application
require File.expand_path('../application', __FILE__)

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => "mail.stips.se",
  :authentication => :login,
  :user_name      => "no-reply",
  :password       => "stips01"
}