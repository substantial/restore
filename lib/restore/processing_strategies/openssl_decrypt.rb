require 'fileutils'

class Restore

  module ProcessingStrategies

    class OpenSSLDecrypt

      def initialize(config)
        @encryption_cipher = config[:encryption_cipher]
        raise ArgumentError unless @encryption_cipher
        @base64 = config[:base64] ? '-base64' : ''
        @salt = config[:salt] ? '-salt' : ''
        @password = config[:password_file] ? "-pass file:#{config[:password_file]}" : ''
      end

      def process(backup_path)
        decrypted_backup_path = backup_path + '-decrypted'
        system("openssl #{@encryption_cipher} -d #{@base64} #{@password} #{@salt} -in #{backup_path} -out #{decrypted_backup_path}")
        return decrypted_backup_path
      end

    end

  end

end
