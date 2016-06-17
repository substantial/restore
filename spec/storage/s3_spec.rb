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

  let(:older_object) { double key: 'my/objects/older/file-path', last_modified: 1 }
  let(:newer_object) { double key: 'my/objects/newer/file-path', last_modified: 2 }
  let(:objects_with_prefix){ [older_object, newer_object] }
  let(:resource) { instance_double Aws::S3::Resource }
  let(:bucket) { instance_double Aws::S3::Bucket }

  let(:subject) { described_class.new config }

  before do
    allow(Dir).to receive(:tmpdir).and_return('/my/tmp/dir/')
    allow(Aws::S3::Resource).to receive(:new).and_return(resource)
    allow(resource).to receive(:bucket).with('pickles').and_return(bucket)
    allow(bucket).to receive(:objects).with(prefix: '/blah/').and_return(objects_with_prefix)
    allow(newer_object).to receive(:get)
  end

  describe '#retrieve' do

    it 'should configure aws s3 correctly' do
      expect(Aws::S3::Resource).to receive(:new).with( access_key_id: 'foo', secret_access_key: 'bar')
      subject.retrieve
    end

    it 'should write the file' do
      expect(newer_object).to receive(:get).with(response_target: "/my/tmp/dir/my-objects-newer-file-path")
      subject.retrieve
    end

    it 'should return the new backup path' do
      expect(subject.retrieve).to eq('/my/tmp/dir/my-objects-newer-file-path')
    end
  end
end
