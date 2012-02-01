# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "browsernizer/version"

Gem::Specification.new do |s|
  s.name        = "browsernizer"
  s.version     = Browsernizer::VERSION
  s.authors     = ["Milovan Zogovic"]
  s.email       = ["milovan.zogovic@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Unsupported browser redirection}
  s.description = %q{Rack middleware for redirecting unsupported browser requests to "please upgrade" page}

  s.rubyforge_project = "browsernizer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
