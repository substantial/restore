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
        return backup_path
      end

      private

      def write_file(filename, data)
        log "writing archive to #{filename}"
        open(filename, 'wb') do |file|
          data.read do |chunk|
            file.write chunk
          end
        end
      end

      def latest_backup
        @_latest_backup ||= begin
                              objects = bucket.objects.with_prefix(@config[:prefix_path])
                              object = objects.sort_by(&:last_modified).last
                              log "found object #{object.key}"
                              object
                            end
      end

      def bucket
        log "looking in bucket #{@config[:bucket_name]}"
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
                   Aws.config(@config)
                   Aws::S3.new
                 end
      end

    end

  end

end
