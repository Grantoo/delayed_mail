module Delayed
  class MailDelivery
    class << self
      attr_accessor :method

      def setup(method)
        ActionMailer::Base.add_delivery_method :delayed, Delayed::MailDelivery
        Delayed::MailDelivery.method = method
      end
    end
 
    def initialize(settings)
    end
 
    def deliver!(mail)
      options = Delayed::Job.new.respond_to?(:queue) ? {:queue => 'mail'} : {}
      self.delay(options).pass_to_delivery_method(mail.encoded)
    end
 
    def pass_to_delivery_method(encoded_message)
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
