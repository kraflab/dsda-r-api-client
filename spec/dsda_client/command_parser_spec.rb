require 'spec_helper'
require 'dsda_client/options'
require 'dsda_client/command_parser'

RSpec.describe DsdaClient::CommandParser do
  let(:options) { instance_double(DsdaClient::Options,
    production?: false, dump_requests?: false) }
  let!(:api) { DsdaClient::Api.setup(options) }
  let(:root_uri) { 'https://test' }
  let(:command_parser) { described_class.new(root_uri, options) }
  let(:data_hash) { { 'player' => { 'name' => 'jeff' } } }
  let(:request_hash) { command_parser.instance_variable_get(:@headers) }

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
        allow(command_parser).to receive(:parse_instance).and_return(true)
        subject
        expect(request_hash['API-USERNAME']).not_to be_nil
        expect(request_hash['API-PASSWORD']).not_to be_nil
      end

      let(:request_service) { DsdaClient::RequestService.new(options) }

      before do
        allow(DsdaClient::RequestService).to receive(:new).and_return(request_service)
        allow(request_service).to receive(:request).and_return(true)
      end

      it 'creates a request' do
        expect(DsdaClient::RequestService).to receive(:new).and_return(request_service)
        expect(request_service).to receive(:request).with(anything, anything, data_hash)
        subject
      end

      context 'invalid instance' do
        let(:data_hash) { { 'player' => { 'foo' => 'jeff' } } }

        it 'tracks an error' do
          expect(DsdaClient::IncidentTracker).to receive(:track)
            .with(:invalid, anything, anything)
          subject
        end
      end

      context 'bad file data' do
        let(:data_hash) do
          {
            'wad' => {
              'author' => 'jeff',
              'iwad' => 'doom',
              'name' => 'jeffwad',
              'short_name' => 'jeffwad',
              'file' => {
                'foo' => 'jeffwad.wad',
                'data' => '[encode]'
              }
            }
          }
        end

        it 'tracks an error' do
          expect(DsdaClient::IncidentTracker).to receive(:track)
            .with(:bad_file, anything, anything)
          subject
        end
      end

      context 'dump_requests? == true' do
        before do
          allow(options).to receive(:dump_requests?).and_return(true)
        end

        it 'tracks the request' do
          expect(DsdaClient::IncidentTracker).to receive(:track)
            .with(:dump, anything, anything)
          subject
        end

        it 'does not post the request' do
          expect(DsdaClient::RequestService).not_to receive(:new)
          subject
        end
      end

      context 'file upload' do
        let(:data_hash) do
          {
            'wad' => {
              'author' => 'jeff',
              'iwad' => 'doom',
              'name' => 'jeffwad',
              'short_name' => 'jeffwad',
              'file' => {
                'name' => 'jeffwad.wad',
                'data' => '[encode]'
              }
            }
          }
        end
        let(:file) { StringIO.new('1234') }
        let(:data) { '1234' }

        before do
          allow(File).to receive(:file?).and_return(true)
          allow(File).to receive(:open).and_return(file)
        end

        it 'base64 encodes the file' do
          expect(Base64).to receive(:encode64).with(data)
          subject
        end
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
