require 'restore/strategy'
require 'fileutils'

class Restore

  module Processor

    module Utility

      class OpenSSLDecrypt < Strategy

        def initialize(config)
          @encryption_cipher = config[:encryption_cipher]
          raise ArgumentError unless @encryption_cipher
          @base64 = config[:base64] ? '-base64' : ''
          @salt = config[:salt] ? '-salt' : ''
          @password = config[:password_file] ? "-pass file:#{config[:password_file]}" : ''
        end

        def process(backup_path)
          decrypted_backup_path = backup_path + '-decrypted'
          log "decrypting #{backup_path} to #{decrypted_backup_path}"
          execute("openssl #{@encryption_cipher} -d #{@base64} #{@password} #{@salt} -in #{backup_path} -out #{decrypted_backup_path}")
          return decrypted_backup_path
        end

      end

    end

  end

end
