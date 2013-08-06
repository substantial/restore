require 'fileutils'
require 'tmpdir'
require 'aws-sdk'

class Restore

  module StorageStrategies

    class S3

      def initialize(config)
        @config = config
        AWS.config(config[:s3_credentials])
        @s3 = AWS::S3.new
      end

      def retrieve
        write_file(backup_path, latest_backup)
        return backup_path
      end

      private

      def latest_backup
        objects.last
      end

      def objects
        bucket.objects.with_prefix(@config[:prefix_path]).sort_by(&:last_modified)
      end

      def bucket
        @s3.buckets[@config[:bucket_name]]
      end

      def backup_path
        @backup_path ||= begin
                        filename = latest_backup.key.gsub('/', '-')
                        File.join(Dir.tmpdir, filename)
                      end
      end

      def write_file(filename, data)
        open(filename, 'wb') do |file|
          data.read do |chunk|
            file.write chunk
          end
        end
      end

    end

  end

end
