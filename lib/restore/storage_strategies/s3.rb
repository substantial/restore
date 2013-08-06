require 'restore/strategy'
require 'fileutils'
require 'tmpdir'
require 'aws-sdk'

class Restore

  module StorageStrategies

    class S3 < Strategy

      def initialize(config)
        @config = config
      end

      def retrieve
        write_file(backup_path, latest_backup)
        return backup_path
      end

      private

      def write_file(filename, data)
        open(filename, 'wb') do |file|
          data.read do |chunk|
            file.write chunk
          end
        end
      end

      def latest_backup
        objects = bucket.objects.with_prefix(@config[:prefix_path])
        objects.sort_by(&:last_modified).last
      end

      def bucket
        s3.buckets[@config[:bucket_name]]
      end

      def backup_path
        @_backup_path ||= begin
                        filename = latest_backup.key.gsub('/', '-')
                        File.join(Dir.tmpdir, filename)
                      end
      end

      def s3
        @_s3 ||= begin
                   AWS.config(@config)
                   AWS::S3.new
                 end
      end

    end

  end

end
