
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rake-tasks-docker-sync/version'

Gem::Specification.new do |spec|
  spec.name          = 'rake-tasks-docker-sync'
  spec.version       = RakeTasksDockerSync::VERSION
  spec.authors       = ['Andy Thompson', 'Kieren Evans']
  spec.email         = ['athompson@inviqa.com', 'kevans+rake-tasks-docker@inviqa.com']

  spec.summary       = 'Docker Sync tasks for Rake'
  spec.description   = 'Docker Sync tasks for Rake'
  spec.homepage      = ''
  spec.licenses = ['MIT']

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rake', '>= 10.0', '<= 13'
  spec.add_dependency 'rake-tasks-docker', '>= 0.2'

  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
end
