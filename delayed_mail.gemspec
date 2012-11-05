# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "delayed_mail/version"

Gem::Specification.new do |s|
  s.name        = "delayed_mail"
  s.version     = DelayedMail::VERSION
  s.authors     = ["Paul Schuegraf"]
  s.email       = ["paul@verticallabs.ca"]
  s.homepage    = ""
  s.summary     = %q{Sends all mail using delayed_job or resque.}
  s.description = %q{Assumes you have dj or resque up and running already.}

  s.rubyforge_project = "delayed_mail"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "delayed_job"
  s.add_development_dependency 'delayed_job_active_record'
  s.add_development_dependency "resque"
  s.add_development_dependency "debugger"
end
