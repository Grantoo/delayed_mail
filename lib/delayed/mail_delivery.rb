require 'action_mailer'

module Delayed
  class MailDelivery
    class << self
      attr_accessor :method, :queue_system

      def setup(method, queue_system)
        ActionMailer::Base.add_delivery_method :delayed, Delayed::MailDelivery
        @method = method
        @queue_system = queue_system

        case queue_system
        when :delayed_job
          require "delayed_mail/backends/delayed_job"
          include DelayedMail::Backends::DelayedJob
        when :resque
          require "delayed_mail/backends/resque"
          include DelayedMail::Backends::Resque
        end
      end
    end
 
    def initialize(settings)
    end
 
    def do_actual_delivery(encoded_message)
      method = self.class.method
      klass = ActionMailer::Base.delivery_methods[method]
      settings = ActionMailer::Base.send(:"#{method.to_s}_settings")
      message = Mail::Message.new(encoded_message)

      begin
        klass.new(settings).deliver!(message)
      rescue Exception => e
        ExceptionNotifier::Notifier.background_exception_notification(e, :data => {:message => "Could not deliver mail message: #{message.subject} to #{message.to.inspect}"})
      end
    end
  end
end
