require 'yaml'
require 'rake-tasks-docker'

module RakeTasksDockerSync
  class Services < RakeTasksDocker::Services
    def initialize(name)
      @services = ["#{name}-sync"]
    end

    def up
      system 'docker-sync', 'start'
    end

    def stop
      system 'docker-sync', 'stop'
    end

    def down
      system 'docker-sync', 'clean'
    end

    def exec(user, command)
      @services.each do |service|
        system 'docker', 'exec', '--user', user, service, command
      end
    end

    protected

    def containers
      `#{@services.map { |service| "docker ps -q -f 'name=#{service}'" }.join(' && ')}`.split("\n")
    end
  end
end
