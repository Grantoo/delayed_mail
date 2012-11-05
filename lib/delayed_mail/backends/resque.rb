require 'resque'

module DelayedMail
  module Backends
    module Resque
      def deliver!(mail)
        ::Resque.enqueue_to('mail', DelayedMail::Backends::Resque::Job, mail.encoded)
      end

      class Job
        def self.perform(mail)
          DelayedMail::Delivery.do_actual_delivery(mail)
        end
      end
    end
  end
end
