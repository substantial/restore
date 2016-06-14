require 'spec_helper'
require 'restore/storage/s3'

describe Restore::Storage::S3 do

  let(:config) do
    {
      :access_key_id => 'foo',
      :secret_access_key => 'bar',
      :prefix_path => '/blah/',
      :bucket_name => 'pickles'
    }
  end

  let(:older_object) do |object|
    double.tap do |object|
      object.stub(:key){ 'my/objects/older/file-path' }
      object.stub(:last_modified){ 1 }
    end
  end

  let(:file) do
    double.tap do |file|
      file.stub(:write)
    end
  end

  let(:chunk){ double }

  let(:newer_object) do |object|
    double.tap do |object|
      object.stub(:key){ 'my/objects/newer/file-path' }
      object.stub(:last_modified){ 2 }
      object.stub(:read).and_yield(chunk)
    end
  end

  let(:objects_with_prefix){ [older_object, newer_object] }

  let(:objects) do
    double.tap do |objects|
      objects.stub(:with_prefix).with(config[:prefix_path]){ objects_with_prefix }
    end
  end

  let(:bucket) do
    double.tap do |bucket|
      bucket.stub(:objects){ objects }
    end
  end

  let(:buckets){ { config[:bucket_name] => bucket } }

  before do
    Aws.stub(:config)

    Aws::S3.stub(:new) do
      double.tap do |s3|
        s3.stub(:buckets){ buckets }
      end
    end

    Dir.stub(:tmpdir){ '/my/tmp/dir' }
    @subject = Restore::Storage::S3.new(config)
  end

  describe '#retrieve' do

    before do
      @subject.stub(:open).and_yield(file)
    end

    it 'should configure aws s3 correctly' do
      Aws.should_receive(:config).with(config)
      @subject.retrieve
    end

    it 'should open the file for writing' do
      @subject.should_receive(:open).with("/my/tmp/dir/my-objects-newer-file-path", "wb")
      @subject.retrieve
    end

    it 'should write the file' do
      file.should_receive(:write).with(chunk)
      @subject.retrieve
    end

    it 'should return the new backup path' do
      @subject.retrieve.should == '/my/tmp/dir/my-objects-newer-file-path'
    end

  end

end
