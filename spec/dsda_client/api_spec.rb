require 'spec_helper'
require 'dsda_client/api'

RSpec.describe DsdaClient::Api do
  let(:production?) { true }

  before do
    allow(DsdaClient::Options).to receive(:production?).and_return(production?)
  end

  describe '.username' do
    subject { described_class.username }

    context 'when the environment key does not exist' do
      before do
        ENV["DSDA_API_USERNAME"] = nil
      end

      it 'raises error' do
        expect { subject }.to raise_error(StandardError)
      end
    end

    context 'when the environment key exists' do
      before do
        ENV["DSDA_API_USERNAME"]     = 'username'
        ENV['DSDA_API_DEV_USERNAME'] = 'dev_username'
      end

      it { is_expected.to eq('username') }

      context 'when not production' do
        let(:production?) { false }

        it { is_expected.to eq('dev_username') }
      end
    end
  end
end
