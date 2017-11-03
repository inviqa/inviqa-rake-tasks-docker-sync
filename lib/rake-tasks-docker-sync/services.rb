require 'yaml'
require 'rake-tasks-docker'

module RakeTasksDockerSync
  class Services < RakeTasksDocker::Services
    def initialize(name)
      @services = ["#{name}-sync"]
    end

    def refresh
      containers = `#{@services.map { |service| "docker ps -q -f 'name=#{service}'" }.join(' && ')}`.split("\n")
      @inspections = []
      containers.each do |container_ref|
        @inspections << JSON.parse(`docker inspect #{container_ref}`).first
      end
    end

    def states
      states = {}
      @inspections.each do |inspection|
        next unless inspection['State']
        state = inspection['State']
        states[inspection['Name']] = if state['Running']
                                       (state['Status']).to_s
                                     elsif state['ExitCode'] > 0
                                       "#{state['Status']} (non-zero exit code)"
                                     else
                                       state['Status']
                                     end
      end
      states
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

    def build
      # no-op
    end

    def exec(user, command)
      @services.each do |service|
        system 'docker', 'exec', '--user', user, service, command
      end
    end
  end
end
