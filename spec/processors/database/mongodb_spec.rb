require 'spec_helper'
require 'restore/processors/database/mongodb'

describe Restore::Processor::Database::MongoDB do

  let(:directory){ '/bar/' }
  let(:config){ {:database_name => 'foo'} }

  before do
    @subject = Restore::Processor::Database::MongoDB.new(config)
    @subject.stub(:execute){ mock }
  end

  describe '#process' do

    it 'should mongorestore with the correct arguments' do
      @subject.should_receive(:execute).with('mongorestore --drop -d foo /bar/')
      @subject.process(directory)
    end

  end

end
