require 'spec_helper'

describe Restore::Strategy do

  before do
    @subject = Restore::Strategy.new
  end

  describe '#log' do

    before do
      $stdout.stub(:puts)
    end

    it 'should log with stars' do
      $stdout.should_receive(:puts).with('*** test '.ljust(70, '*'))
      @subject.log('test')
    end

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
