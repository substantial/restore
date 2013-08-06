require 'spec_helper'

describe Restore do

  let(:backup){ mock }
  let(:storage_strategy){ mock('storage strategy', :retrieve => backup) }
  let(:processed_by_1){ mock }
  let(:processed_by_both){ mock }
  let(:processing_strategy_1) do
    mock.tap do |processing_strategy_1|
      processing_strategy_1.stub(:process).with(backup){ processed_by_1 }
    end
  end
  let(:processing_strategy_2) do
    mock.tap do |processing_strategy_2|
      processing_strategy_2.stub(:process).with(processed_by_1){ processed_by_both }
    end
  end
  let(:processing_strategies){ [processing_strategy_1, processing_strategy_2] }
  let(:database_strategy){ mock('database strategy', :restore_from_archive => mock )}

  before do
    @subject = Restore.new(storage_strategy, processing_strategies, database_strategy)
  end

  describe '#run' do

    it 'should use the database strategy to restore from the retrieved archive' do
      database_strategy.should_receive(:restore_from).with(processed_by_both)
      @subject.run
    end

  end

end
