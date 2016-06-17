require 'restore/strategy'

class Restore
  module Processor
    module Database
      class MongoDB < Strategy
        def initialize(config)
          @config = config
        end

        def process(backup_path)
          parameters = ['--drop']
          parameters << "--host #{@config[:host]}" if @config.key? :host
          parameters << "--port #{@config[:port]}" if @config.key? :port
          parameters << "-d #{@config[:database_name]} #{backup_path}"

          execute("mongorestore #{parameters.join(' ')}")
        end
      end
    end
  end
end
