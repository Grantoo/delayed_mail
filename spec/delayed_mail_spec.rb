require 'spec_helper'

describe ActionMailer::Base do
  context 'DelayedJob' do
    before(:each) do
      DelayedMail::Delivery.setup(:smtp, :delayed_job)
      ActionMailer::Base.delivery_method = :delayed
      Delayed::Job.destroy_all
    end

    it 'should be configured to use delayed mail' do
      ActionMailer::Base.delivery_method.should == :delayed
    end

    it "puts a message into the job queue" do
      ActionMailer::Base.mail(:to => 'test@verticallabs.ca', :from => 'test@verticallabs.ca', :body => 'RSpec tests!').deliver
      Delayed::Job.all.length.should == 1
    end

    it 'recreates the message from the queue correctly' do
      original = ActionMailer::Base.mail(:to => 'test@verticallabs.ca', :from => 'test@verticallabs.ca', :body => 'RSpec tests!').deliver
      copy = Mail::Message.new(Delayed::Job.first.payload_object.args[0])
      original.should == copy
    end
  end

  context 'Resque' do
    before(:each) do
      DelayedMail::Delivery.setup(:smtp, :resque)
      ActionMailer::Base.delivery_method = :delayed
      Resque.redis.del('queue:mail')
    end

    it 'should be configured to use delayed mail' do
      ActionMailer::Base.delivery_method.should == :delayed
    end

    it "puts a message into the job queue" do
      ActionMailer::Base.mail(:to => 'test@verticallabs.ca', :from => 'test@verticallabs.ca', :body => 'RSpec tests!').deliver
      Resque.size('mail').should == 1
    end

    it 'recreates the message from the queue correctly' do
      original = ActionMailer::Base.mail(:to => 'test@verticallabs.ca', :from => 'test@verticallabs.ca', :body => 'RSpec tests!').deliver
      copy = Mail::Message.new(Resque.peek('mail')['args'][0])
      original.should == copy
    end
  end
end
