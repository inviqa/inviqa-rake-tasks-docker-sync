# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rake-tasks-docker-sync/version'

Gem::Specification.new do |spec|
  spec.name          = "rake-tasks-docker-sync"
  spec.version       = RakeTasksDockerSync::VERSION
  spec.authors       = ["Andy Thompson", "Kieren Evans"]
  spec.email         = ["athompson@inviqa.com", "kevans+rake-tasks-docker@inviqa.com"]

  spec.summary       = %q{Docker Sync tasks for Rake}
  spec.description   = %q{Docker Sync tasks for Rake}
  spec.homepage      = ""
  spec.licenses = ["MIT"]

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rake", ">= 10.0", "<= 12"
  spec.add_dependency "rake-tasks-docker"
  spec.add_dependency "docker-sync"

  spec.add_development_dependency "rspec", "~> 3.6"
end
