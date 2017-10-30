require_relative 'services'

namespace :docker do
  namespace :sync do
    def name_from_hem_config
      name = ''
      hem_config = nil
      %w[tools/hem/config.yaml tools/hobo/config.yaml].each do |file|
        hem_config = YAML.load_file(file) if !hem_config && File.exist?(file)
      end
      name = hem_config[:name] if hem_config
      name
    end

    def sync_services_from_args(args)
      name = args[:name]
      name ||= name_from_hem_config
      RakeTasksDockerSync::Services.new(name)
    end

    task :start, :name do |_task, args|
      puts '==> Starting docker-sync:'
      services = sync_services_from_args(args)
      if services.status != 'started'
        services.up
        puts "==> docker-sync started\n\n"
      else
        puts "==> docker-sync already started\n\n"
      end
    end

    task :status, :name do |_task, args|
      services = sync_services_from_args(args)
      puts services.status
      exit(1) if services.status != 'started'
    end

    task :stop, :name do |_task, args|
      puts '==> Stopping docker-sync:'
      services = sync_services_from_args(args)
      if services.status == 'started'
        services.stop
        puts "==> docker-sync stopped\n\n"
      else
        puts "==> docker-sync not running\n\n"
      end
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
