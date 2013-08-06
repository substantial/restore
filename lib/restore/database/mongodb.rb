require 'restore/strategy'

class Restore

  module Database

    class MongoDB < Strategy

      def initialize(config)
        @config = config
      end

      def restore_from(backup_path)
        execute("mongorestore --drop -d #{@config[:database_name]} #{backup_path}")
      end

    end

  end

end
