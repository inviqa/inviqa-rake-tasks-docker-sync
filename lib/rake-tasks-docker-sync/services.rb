require 'yaml'
require 'rake-tasks-docker'

module RakeTasksDockerSync
  class Services < RakeTasksDocker::Services
    def self.from_args(_args)
      raise 'No docker-sync.yml configuration found in your path' unless File.exist?('docker-sync.yml')

      docker_sync_config = YAML.load_file('docker-sync.yml')

      self.new(docker_sync_config['syncs'].keys)
    end

    def initialize(syncs)
      @services = syncs
    end

    def up
      execute do
        system 'docker-sync', 'start'
      end
    end

    def stop
      execute do
        system 'docker-sync', 'stop'
      end
    end

    def down
      execute do
        system 'docker-sync', 'clean'
      end
    end

    def exec(user, command)
      @services.each do |service|
        execute do
          system 'docker', 'exec', '--user', user, service, command
        end
      end
    end

    protected

    def execute(&block)
      if defined?(Bundler)
        Bundler.with_clean_env do
          yield block
        end
      else
        yield block
      end
    end

    def containers
      `#{@services.map { |service| "docker ps -q -f 'name=#{service}'" }.join(' && ')}`.split("\n")
    end
  end
end
