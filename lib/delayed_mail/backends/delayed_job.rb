require 'delayed_job'

module DelayedMail
  module Backends
    module DelayedJob
      def deliver!(mail)
        options = Delayed::Job.new.respond_to?(:queue) ? {:queue => 'mail'} : {}
        self.class.delay(options).do_actual_delivery(mail.encoded)
      end
    end
  end
end
