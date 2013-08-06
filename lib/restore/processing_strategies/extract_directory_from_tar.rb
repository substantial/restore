require 'fileutils'

class Restore

  module ProcessingStrategies

    class ExtractDirectoryFromTar

      def initialize(config)
        @config = config
      end

      def process(backup_path)
        Dir.chdir(Dir.tmpdir)
        working_dir = @config[:working_directory]
        FileUtils.rm_rf(working_dir)
        Dir.mkdir(working_dir)
        Dir.chdir(working_dir)
        execute("tar -xf #{backup_path}")
        backup_path = Dir.glob("**/#{@config[:directory_to_extract]}").first
        return backup_path
      end

    end

  end

end
