require 'restore/strategy'

class Restore

  module Database

    class MongoDB < Strategy

      def initialize(config)
        @config = config
      end

      def restore_from(directory)
        execute("mongorestore --drop -d #{@config[:database_name]} #{directory}")
      end

    end

  end

end
