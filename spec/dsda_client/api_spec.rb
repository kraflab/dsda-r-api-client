require 'spec_helper'
require 'dsda_client/api'

RSpec.describe DsdaClient::Api do
  describe '.key' do
    context 'key not found' do
      it 'raises error' do
        expect { described_class.not_a_key }.to raise_error(StandardError)
      end
    end

    context 'key found' do
      it 'returns the environment key' do
        ENV["DSDA_API_SOMETHING"] = 'something'
        expect(described_class.something).to eq('something')
      end
    end
  end
end
