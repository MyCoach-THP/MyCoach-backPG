# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# ActionMailer::Base.smtp_settings = {
# :user_name => 'apikey',
# :password => ENV['SENDGRID_PWD'],
# :domain => 'monsite.fr',
# :address => 'smtp.sendgrid.net',
# :port => 587,
# :authentication => :plain,
# :enable_starttls_auto => true
# }
# #ou bien:
ActionMailer::Base.smtp_settings = {
:user_name => 'gregimbeau@gmail.com',
:password => ENV['BREVO_PWD'],
:domain => 'monsite.fr',
:address => 'smtp-relay.sendinblue.com',
:port => 587,
:authentication => :plain,
:enable_starttls_auto => true
}