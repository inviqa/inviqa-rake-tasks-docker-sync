require_relative 'services'

namespace :docker do
  namespace :sync do
    def sync_services_from_args(args)
      RakeTasksDockerSync::Services.new(args[:name] ? args[:name].split(' ') : [])
    end

    task :start, :name do |_task, args|
      puts '==> Starting docker-sync:'
      services = sync_services_from_args(args)
      services.up
      puts "==> docker-sync started\n\n"
    end

    task :stop, :name do |_task, args|
      puts '==> Stopping docker-sync:'
      services = sync_services_from_args(args)
      services.stop
      puts "==> docker-sync stopped\n\n"
    end

    task :clean, :name do |_task, args|
      puts '==> Removing docker-sync container and volume:'
      services = sync_services_from_args(args)
      services.down
      puts "==> docker-sync container and volume cleaned\n\n"
    end
  end
end

if RUBY_PLATFORM =~ /darwin/
  Rake::Task['docker:start'].enhance(['docker:sync:start'])
  Rake::Task['docker:stop'].enhance do
    Rake::Task['docker:sync:stop'].invoke
  end
  Rake::Task['docker:destroy'].enhance do
    Rake::Task['docker:sync:clean'].invoke
  end
end
