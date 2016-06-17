require 'restore/strategy'
require 'fileutils'
require 'tmpdir'
require 'aws-sdk'

class Restore
  module Storage
    class S3 < Strategy
      def initialize(config)
        @config = config
      end

      def retrieve
        write_file(backup_path, latest_backup)
        backup_path
      end

      private

      def write_file(filename, object)
        log "writing archive to #{filename}"
        object.get response_target: filename
      end

      def latest_backup
        @_latest_backup ||= begin
                              objects = bucket.objects prefix: @config[:prefix_path]
                              object = objects.sort_by(&:last_modified).last
                              log "found object #{object.key}"
                              object
                            end
      end

      def bucket
        log "looking in bucket #{@config[:bucket_name]}"
        s3.bucket @config[:bucket_name]
      end

      def backup_path
        @_backup_path ||= begin
                            filename = latest_backup.key.tr('/', '-')
                            File.join(Dir.tmpdir, filename)
                          end
      end

      def s3
        @_s3 ||= Aws::S3::Resource.new @config.reject { |k| [:prefix_path, :bucket_name].include? k }
      end
    end
  end
end
