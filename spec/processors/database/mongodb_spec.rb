require 'spec_helper'
require 'restore/processors/database/mongodb'

describe Restore::Processor::Database::MongoDB do
  let(:directory) { '/bar/' }
  let(:config) { { database_name: 'foo' } }

  before do
    @subject = Restore::Processor::Database::MongoDB.new(config)
    @subject.stub(:execute) { double }
  end

  describe '#process' do
    context 'minimum config' do
      it 'should mongorestore with the correct arguments' do
        @subject.should_receive(:execute).with('mongorestore --drop -d foo /bar/')
        @subject.process(directory)
      end
    end

    context 'with host config' do
      let(:config) { { database_name: 'foo', host: 'host_name', port: '3025' } }

      it 'should mongorestore with the host' do
        @subject.should_receive(:execute).with('mongorestore --drop --host host_name --port 3025 -d foo /bar/')
        @subject.process(directory)
      end
    end
  end
end
