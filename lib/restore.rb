require "restore/version"

class Restore

  def initialize(storage_strategy, processing_strategies, database_strategy)
    @storage_strategy = storage_strategy
    @processing_strategies = processing_strategies
    @database_strategy = database_strategy
  end

  def run
    backup_path = @storage_strategy.retrieve
    @processing_strategies.each do |strategy|
      backup_path = strategy.process(backup_path)
    end
    @database_strategy.restore_from(backup_path)
  end

  protected

  def execute(command)
    system(command)
  end

end
