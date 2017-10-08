require 'spec_helper'
require 'dsda_client/options'

RSpec.describe DsdaClient::Options do
  describe 'defaults' do
    subject(:options) { described_class.new([]) }

    it { expect(options.dump_requests?).to be false }
    it { expect(options.production?).to be true }
    it { expect(options.post?).to be false }
  end

  describe '#dump_requests?' do
    context '--dump-requests option used' do
      it 'returns true' do
        expect(described_class.new(['--dump-requests']).dump_requests?).to be true
      end
    end
  end

  describe '#production?' do
    context '--local option used' do
      it 'returns false' do
        expect(described_class.new(['--local']).production?).to be false
      end
    end
  end

  describe '#post?' do
    context '--post options used' do
      it 'returns true' do
        expect(described_class.new(['--post']).post?).to be true
      end
    end
  end
end
