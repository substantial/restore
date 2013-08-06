require 'spec_helper'
require 'restore/storage/rsync'

describe Restore::Storage::Rsync do

  let(:config) do
    {
      :flags => '--blah',
      :remote_source => 'my.remote.host:/remote/path',
      :local_destination => '/my/local/destination'
    }
  end

  context 'all required configuration options provided' do

    before do
      @subject = Restore::Storage::Rsync.new(config)
      @subject.stub(:execute)
    end

    describe '#retrieve' do

      it 'should execute the correct rsync command' do
        @subject.should_receive(:execute).with('rsync --blah my.remote.host:/remote/path /my/local/destination')
        @subject.retrieve
      end

    end

  end

  context 'default flags' do

    before do
      config.delete(:flags)
      @subject = Restore::Storage::Rsync.new(config)
      @subject.stub(:execute)
    end

    describe '#retrieve' do

      it 'should execute the correct rsync command' do
        @subject.should_receive(:execute).with('rsync -rzvh --size-only --progress my.remote.host:/remote/path /my/local/destination')
        @subject.retrieve
      end

    end

  end

  context 'missing required configuration option remote_source' do

    before do
      config.delete(:remote_source)
    end

    it 'should raise an argument error' do
      expect do
        Restore::Storage::Rsync.new(config)
      end.to raise_error ArgumentError, "Missing required configuration key: remote_source"
    end

  end

  context 'missing required configuration option local_destination' do

    before do
      config.delete(:local_destination)
    end

    it 'should raise an argument error' do
      expect do
        Restore::Storage::Rsync.new(config)
      end.to raise_error ArgumentError, "Missing required configuration key: local_destination"
    end

  end

end
