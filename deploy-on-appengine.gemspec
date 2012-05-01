# -*- encoding: utf-8 -*-
require File.expand_path('../lib/deploy-on-appengine/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["siddick"]
  gem.email         = ["siddick@gmail.com"]
  gem.description   = %q{Scripts to deploy latest rails on appengine}
  gem.summary       = %q{deploy rails on appengine}
  gem.homepage      = ""

  gem.bindir        = "bin"
  gem.executables   = %w(appcfg dev_appserver)
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "deploy-on-appengine"
  gem.require_paths = ["lib"]
  gem.version       = Deploy::On::Appengine::VERSION

  gem.add_runtime_dependency "appengine-tools"
end
