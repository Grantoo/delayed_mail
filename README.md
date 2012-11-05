DelayedMail
===========

This is intended to encapsulate necessary functionality to send your emails using a background queueing system.

To use:

        Delayed::MailDelivery.setup(:smtp, :delayed_job) # or :resque
        ActionMailer::Base.delivery_method = :delayed

Currently supports DelayedJob and Resque as backends.
