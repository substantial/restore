require 'spec_helper'
require 'restore/processors/utility/extract_from_tar'

describe Restore::Processor::Utility::ExtractFromTar do

  let(:backup){ '/thing' }
  let(:extracted_backup){ mock }
  let(:config) do
    {
      :extract_path => 'backup_directory',
      :working_directory => 'blah'
    }
  end

  describe 'process' do

    before do
      Dir.stub(:tmpdir){ '/tmp/foo' }
      Dir.stub(:chdir)
      Dir.stub(:mkdir)
      FileUtils.stub(:rm_rf)
    end

    context 'extract path included' do

      before do
        @subject = Restore::Processor::Utility::ExtractFromTar.new(config)
        @subject.stub(:execute)
        Dir.stub(:glob).with("**/#{config[:extract_path]}"){ [extracted_backup] }
      end

      it 'should remove any working directory that might already be there' do
        FileUtils.should_receive(:rm_rf).with('/tmp/foo/blah')
        @subject.process(backup)
      end

      it 'should make a new working directory' do
        Dir.should_receive(:mkdir).with('/tmp/foo/blah')
        @subject.process(backup)
      end

      it 'should change directorys to the working directory' do
        Dir.should_receive(:chdir).with('/tmp/foo/blah')
        @subject.process(backup)
      end

      it 'should execute the tar exctraction command' do
        @subject.should_receive(:execute).with("tar -xf #{backup}")
        @subject.process(backup)
      end

      it 'should return the backup path' do
        @subject.process(backup).should == extracted_backup
      end

    end

    context 'extract path not included' do

      before do
        config.delete(:extract_path)
        @subject = Restore::Processor::Utility::ExtractFromTar.new(config)
        @subject.stub(:execute)
      end

      it 'should return the working directory' do
        @subject.process(backup).should == '/tmp/foo/blah'
      end

    end

  end

end
