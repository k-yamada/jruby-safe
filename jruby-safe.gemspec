# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sandbox/version"

Gem::Specification.new do |s|
  s.name        = "jruby-safe"
  s.version     = Sandbox::VERSION
  s.platform    = "java"
  s.authors     = ["Kazuhiro yamada"]
  s.email       = ["yamadakazu45@gmail.com"]
  s.homepage    = "http://github.com/k-yamada/jruby-safe"
  s.summary     = "Sandbox support for JRuby"
  s.description = "A version of _why's Freaky Freaky Sandbox for JRuby."

  s.files         = `git ls-files`.split("\n") + ["lib/sandbox/sandbox.jar"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "fakefs"

  s.add_development_dependency "rake"
  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"
end
