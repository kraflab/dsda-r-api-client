require 'spec_helper'
require 'dsda_client/command_parser'

RSpec.describe DsdaClient::CommandParser do
  let(:options) { instance_double(DsdaClient::Options, post?: true, production?: false) }
  let!(:api) { DsdaClient::Api.setup(options) }
  let(:root_uri) { 'https://test' }
  let(:command_parser) { described_class.new(root_uri, options) }
  let(:data_hash) { {} }
  let(:request_hash) { command_parser.instance_variable_get(:@request_hash) }

  describe '#parse' do
    subject { command_parser.parse(data_hash) }

    context 'plural model name' do
      let(:data_hash) { { 'demos' => [] } }

      it 'singularizes model names' do
        expect(command_parser).to receive(:unknown_model?)
          .with('demo', anything)
        subject
      end
    end

    context 'post request' do
      it 'sets credentials in the header' do
        subject
        expect(request_hash['API-USERNAME']).not_to be_nil
        expect(request_hash['API-PASSWORD']).not_to be_nil
      end
    end

    context 'unsupported model' do
      let(:data_hash) { { 'user' => { 'name' => 'jeff' } } }

      it 'skips the batch' do
        expect(command_parser).not_to receive(:parse_batch)
        subject
      end

      it 'tracks an error' do
        expect(DsdaClient::IncidentTracker).to receive(:track)
          .with(:unknown_model, anything, anything)
        subject
      end
    end
  end
end
