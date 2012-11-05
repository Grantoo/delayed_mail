require 'resque'

module DelayedMail
  module Backends
    module Resque
      def deliver!(mail)
        ::Resque.enqueue_to('mail', self, mail.encoded)
      end

      def perform(mail)
        self.do_actual_delivery(mail)
      end
    end
  end
end
