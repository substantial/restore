require 'restore/strategy'

class Restore

  module Processor

    module Database

      class MySQL < Strategy

        def initialize(config)
          @user = config[:user] ? "--user=#{config[:user]}" : ''
          @password = config[:password] ? "--password=#{config[:password]}" : ''
          @database = config[:database]
          raise ArgumentError unless @database
          @drop = config[:drop]
          @create = config[:create]
        end

        def process(backup_path)
          mysql_command("--execute='drop database #{@database}'") if @drop
          mysql_command("--execute='create database #{@database}'") if @create
          mysql_command("#{@database} < #{backup_path}")
        end

        private

        def mysql_command(cmd)
          execute("mysql #{@user} #{@password} #{cmd}".squeeze(' ').strip)
        end

      end

    end

  end

end
