require 'spec_helper'
require 'restore/processing_strategies/extract_directory_from_tar'

describe Restore::ProcessingStrategies::ExtractDirectoryFromTar do

  let(:backup){ '/thing' }
  let(:extracted_backup){ mock }
  let(:config) do
    {
      :directory_to_extract => 'backup_directory',
      :working_directory => 'blah'
    }
  end

  before do
    @subject = Restore::ProcessingStrategies::ExtractDirectoryFromTar.new(config)
  end

  describe 'process' do

    before do
      Dir.stub(:tmpdir){ '/tmp/foo' }
      Dir.stub(:chdir)
      Dir.stub(:mkdir)
      FileUtils.stub(:rm_rf)
      @subject.stub(:execute)
      Dir.stub(:glob).with("**/#{config[:directory_to_extract]}"){ [extracted_backup] }
    end

    it 'should change directorys to the tmpdir' do
      Dir.should_receive(:chdir).with('/tmp/foo')
      @subject.process(backup)
    end

    it 'should remove any working directory that might already be there' do
      FileUtils.should_receive(:rm_rf).with(config[:working_directory])
      @subject.process(backup)
    end

    it 'should make a new working directory' do
      Dir.should_receive(:mkdir).with(config[:working_directory])
      @subject.process(backup)
    end

    it 'should change directorys to the working directory' do
      Dir.should_receive(:chdir).with(config[:working_directory])
      @subject.process(backup)
    end

    it 'should execute the tar exctraction command' do
      @subject.should_receive(:execute).with("tar -xf #{backup}")
      @subject.process(backup)
    end

    it 'should return the backup directory' do
      @subject.process(backup).should == extracted_backup
    end

  end

end
