require 'restore/strategy'

class Restore

  module Processor

    module Database

      class MongoDB < Strategy

        def initialize(config)
          @config = config
        end

        def process(backup_path)
          execute("mongorestore --drop -d #{@config[:database_name]} #{backup_path}")
        end

      end

    end

  end

end
