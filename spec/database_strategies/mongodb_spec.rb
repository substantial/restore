require 'spec_helper'
require 'restore/database_strategies/mongodb'

describe Restore::DatabaseStrategies::MongoDB do

  let(:directory){ '/bar/' }
  let(:config){ {:database_name => 'foo'} }

  before do
    @subject = Restore::DatabaseStrategies::MongoDB.new(config)
    @subject.stub(:execute){ mock }
  end

  describe '#restore_from' do

    it 'should mongorestore with the correct arguments' do
      @subject.should_receive(:execute).with('mongorestore --drop -d foo /bar/')
      @subject.restore_from(directory)
    end

  end

end
