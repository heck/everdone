# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'everdone/version'

Gem::Specification.new do |spec|
  spec.name          = "everdone"
  spec.version       = Everdone::VERSION
  spec.authors       = ["Steve Heckt"]
  spec.email         = ["home@u2me.com"]
  spec.summary       = %q{Syncs completed Todoist items into Evernote}
  spec.description   = %q{Uses Todoist and Evernote web services (and their respective API tokesn) }
  spec.homepage      = "http://github.com/heck/everdone"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "evernote-thrift", "~> 1.25"
  spec.add_runtime_dependency "evernote_oauth", "~> 0.2"
  spec.add_runtime_dependency "httparty", "~> 0.13"
  spec.add_runtime_dependency "json", "~> 1.8"
  spec.add_runtime_dependency "oauth", "~> 0.4"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "awesome_print"
end
