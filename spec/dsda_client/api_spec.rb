require 'spec_helper'
require 'dsda_client/api'

RSpec.describe DsdaClient::Api do
  let(:production_options) { double(production?: true) }

  before do
    described_class.setup(production_options)
    ENV["DSDA_API_SOMETHING"]     = 'something'
    ENV['DSDA_API_DEV_SOMETHING'] = 'dev_something'
  end

  describe '.key' do
    context 'key does not exist' do
      it 'raises error' do
        expect { described_class.not_a_key }.to raise_error(StandardError)
      end
    end

    context 'key exists' do
      it 'returns the environment key' do
        expect(described_class.something).to eq('something')
      end

      context 'development environment' do
        let(:development_options) { double(production?: false) }

        it 'returns the development environment key' do
          described_class.setup(development_options)
          expect(described_class.something).to eq('dev_something')
        end
      end
    end
  end
end
