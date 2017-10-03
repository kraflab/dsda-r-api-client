require 'spec_helper'
require 'dsda_client/options'

RSpec.describe DsdaClient::Options do
  describe 'dump_requests?' do
    context '--dump-requests option used' do
      it 'returns true' do
        expect(described_class.new(['--dump-requests']).dump_requests?).to be true
      end
    end

    context 'no option used' do
      it 'returns false' do
        expect(described_class.new([]).dump_requests?).to be false
      end
    end
  end

  describe 'production?' do
    context '--local option used' do
      it 'returns false' do
        expect(described_class.new(['--local']).production?).to be false
      end
    end

    context 'no option used' do
      it 'returns true' do
        expect(described_class.new([]).production?).to be true
      end
    end
  end
end
