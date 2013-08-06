class Restore

  class Strategy

    def log(msg = '')
      $stdout.puts "*** #{msg} ".ljust(70, '*')
    end

    def execute(command)
      log command
      system(command)
    end

  end

end
