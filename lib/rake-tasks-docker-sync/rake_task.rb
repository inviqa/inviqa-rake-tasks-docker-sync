require_relative 'services'

namespace :docker do
  namespace :sync do
    RakeTasksDockerSync::Services.task :start do |_task, services|
      puts '==> Starting docker-sync:'
      if services.status != 'started'
        services.up
        puts "==> docker-sync started\n\n"
      else
        puts "==> docker-sync already started\n\n"
      end
    end

    RakeTasksDockerSync::Services.task :status do |_task, services|
      puts services.status
      exit(1) if services.status != 'started'
    end

    RakeTasksDockerSync::Services.task :stop do |_task, services|
      puts '==> Stopping docker-sync:'
      if services.status == 'started'
        services.stop
        puts "==> docker-sync stopped\n\n"
      else
        puts "==> docker-sync not running\n\n"
      end
    end

    RakeTasksDockerSync::Services.task :clean do |_task, services|
      puts '==> Removing docker-sync container and volume:'
      services.down
      puts "==> docker-sync container and volume cleaned\n\n"
    end
  end
end

if RUBY_PLATFORM =~ /darwin/ && %w[true yes y].include?(ENV['RAKE_USE_DOCKER_SYNC'])
  Rake::Task['docker:up'].enhance(['docker:sync:start'])
  Rake::Task['docker:stop'].enhance do
    Rake::Task['docker:sync:stop'].invoke
  end
  Rake::Task['docker:down'].enhance do
    Rake::Task['docker:sync:clean'].invoke
  end
end
