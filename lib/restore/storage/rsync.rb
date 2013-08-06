require 'restore/strategy'

class Restore

  module Storage

    class Rsync < Strategy

      def initialize(config)
        @flags = config[:flags] || "-rzvh --size-only --progress"
        raise_unless(config, :remote_source)
        raise_unless(config, :local_destination)
        @remote_source = config[:remote_source]
        @local_destination = config[:local_destination]
      end

      def retrieve
        execute("rsync #{@flags} #{@remote_source} #{@local_destination}")
        return @local_destination
      end

      private

      def raise_unless(config, key)
        return if config[key]
        raise ArgumentError, "Missing required configuration key: #{key}"
      end

    end

  end

end
