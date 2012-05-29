require 'rails'
require 'delayed/mail_delivery'

class DelayedMailRailTie < Rails::Railtie
  config.before_configuration do
    Delayed::MailDelivery.setup(:smtp)
    config.action_mailer.delivery_method = :delayed
  end
end
