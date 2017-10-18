require_relative 'services'

namespace :docker do
  namespace :sync do
    def services_from_args(args)
      RakeTasksDockerSync::Services.new(args[:name] ? args[:name].split(' ') : [])
    end

    task :start, :name do |task, args|
      services = services_from_args(args)
      services.up
    end

    task :clean, :name do |task, args|
      services = services_from_args(args)
      services.clean
    end
  end
end

Rake::Task['docker:start'].enhance(['docker:sync:start'])
Rake::Task['docker:destroy'].enhance do
  Rake::Task['docker:sync:clean'].invoke
end
