require 'restore'
require 'restore/strategy'

class Restore
  class Strategy
    def log(arg)
    end
  end
end

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :progress

  config.fail_fast = true

  config.order = :rand
end
