require "restore/version"

class Restore

  def initialize(storage, processors)
    @storage = storage
    @processors = processors
  end

  def run
    backup_path = @storage.retrieve
    return unless @processors
    @processors.each do |processor|
      backup_path = processor.process(backup_path)
    end
  end

end
