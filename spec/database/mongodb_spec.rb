require 'spec_helper'
require 'restore/database/mongodb'

describe Restore::Database::MongoDB do

  let(:directory){ '/bar/' }
  let(:config){ {:database_name => 'foo'} }

  before do
    @subject = Restore::Database::MongoDB.new(config)
    @subject.stub(:execute){ mock }
  end

  describe '#restore_from' do

    it 'should mongorestore with the correct arguments' do
      @subject.should_receive(:execute).with('mongorestore --drop -d foo /bar/')
      @subject.restore_from(directory)
    end

  end

end
