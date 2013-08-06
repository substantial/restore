require "restore/version"

class Restore

  def initialize(storage_strategy, processing_strategies, database_strategy)
    @storage_strategy = storage_strategy
    @processing_strategies = processing_strategies
    @database_strategy = database_strategy
  end

  def run
    backup = @storage_strategy.retrieve
    @processing_strategies.each do |strategy|
      backup = strategy.process(backup)
    end
    @database_strategy.restore_from(backup)
  end

  protected

  def execute(command)
    system(command)
  end

end
