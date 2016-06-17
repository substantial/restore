require 'spec_helper'

describe Restore do

  let(:backup_path){ double }
  let(:storage){ double 'storage', :retrieve => backup_path }
  let(:processed_by_1){ double }
  let(:processor_1) do
    double.tap do |processor_1|
      processor_1.stub(:process).with(backup_path){ processed_by_1 }
    end
  end
  let(:processor_2) do
    double.tap do |processor_2|
      processor_2.stub(:process).with(processed_by_1)
    end
  end
  let(:processors){ [processor_1, processor_2] }

  before do
    @subject = Restore.new(storage, processors)
  end

  describe '#run' do

    it 'should retrieve the stored backup' do
      storage.should_receive(:retrieve)
      @subject.run
    end

    it 'should process the backup_path' do
      processor_1.should_receive(:process).with(backup_path)
      processor_2.should_receive(:process).with(processed_by_1)
      @subject.run
    end

  end

  context 'optional processors' do

    it 'should not raise if the processors argument is not included' do
      expect do
        Restore.new(:foo)
      end.to_not raise_error
    end

  end

end
