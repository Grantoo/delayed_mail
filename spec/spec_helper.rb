# This file is copied to spec/ when you run "rails generate rspec:install"
# datamapper
require 'action_mailer'
require 'dm-core'
require 'dm-migrations'
require 'delayed_job_data_mapper'
require 'delayed_job'
require 'delayed/mail_delivery'

DataMapper.finalize
DataMapper.setup(:default, :adapter => 'in_memory')
DataMapper.auto_migrate!

Delayed::MailDelivery.setup(:smtp)
ActionMailer::Base.delivery_method = :delayed

# rspec
RSpec.configure do |config|
  config.before(:each) do
    Delayed::Job.all.destroy
  end
end
