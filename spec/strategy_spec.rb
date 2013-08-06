require 'spec_helper'

describe Restore::Strategy do

  before do
    @subject = Restore::Strategy.new
  end

  describe '#execute' do

    before do
      @subject.stub(:log)
      @subject.stub(:system)
    end

    it 'should log the command' do
      @subject.should_receive(:log).with('test')
      @subject.execute('test')
    end

    it 'should execute the command' do
      @subject.should_receive(:system).with('test')
      @subject.execute('test')
    end

  end

end
