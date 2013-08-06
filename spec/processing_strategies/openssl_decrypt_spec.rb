require 'spec_helper'
require 'restore/processing_strategies/openssl_decrypt'

describe Restore::ProcessingStrategies::OpenSSLDecrypt do

  let(:backup_path){ '/backup/path' }

  let(:config) do
    {
      :encryption_cipher => 'pancakes',
      :base64 => true,
      :salt => true,
      :password_file => '/foo/bar/baz'
    }
  end

  context 'valid arguments provided' do

    before do
      @subject = Restore::ProcessingStrategies::OpenSSLDecrypt.new(config)
      @subject.stub(:system)
    end

    describe '#process' do

      it 'should make the correct system call' do
        @subject.should_receive(:system).with('openssl pancakes -d -base64 -pass file:/foo/bar/baz -salt -in /backup/path -out /backup/path-decrypted')
        @subject.process(backup_path)
      end

      it 'should return the new path' do
        @subject.process(backup_path).should == '/backup/path-decrypted'
      end

    end

  end

  context 'invalid arguments provided' do

    before do
      config.delete(:encryption_cipher)
    end

    it 'should raise an argument error when missing the encryption cipher' do
      expect do
        Restore::ProcessingStrategies::OpenSSLDecrypt.new(config)
      end.to raise_error ArgumentError
    end

  end

end
