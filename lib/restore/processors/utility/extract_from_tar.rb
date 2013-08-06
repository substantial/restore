require 'restore/strategy'
require 'fileutils'

class Restore

  module Processor

    module Utility

      class ExtractFromTar < Strategy

        def initialize(config)
          @working_directory = config[:working_directory]
          @extract_path = config[:extract_path]
        end

        def process(backup_path)
          working_directory = File.join(Dir.tmpdir, @working_directory)
          FileUtils.rm_rf(working_directory)
          Dir.mkdir(working_directory)
          Dir.chdir(working_directory)
          execute("tar -xf #{backup_path}")
          return working_directory unless @extract_path
          extract_path = Dir.glob("**/#{@extract_path}").first
          return extract_path
        end

      end

    end

  end

end
