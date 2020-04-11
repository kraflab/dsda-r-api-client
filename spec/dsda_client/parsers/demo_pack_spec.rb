require 'spec_helper'
require 'dsda_client/command_parser'
require 'dsda_client/parsers/demo_pack'

describe DsdaClient::Parsers::DemoPack do
  let(:headers) { {} }
  let(:root_uri) { 'foo' }
  let(:instance) do
    {
      'file' => {
        'name' => 'foo.zip',
        'data' => 'FoO'
      },
      'demos' => [
        { },
        { }
      ]
    }
  end
  let(:parser) do
    described_class.new(instance, root_uri, headers)
  end
  let(:response) do
    {
      'save' => true,
      'demo' => {
        'file_id' => 123
      }
    }
  end
  let(:requester) { instance_double(DsdaClient::RequestService) }

  subject { described_class.call(instance, root_uri, headers) }

  before do
    allow(described_class).to receive(:new).and_return(parser)
    allow(parser).to receive(:parse_file_data).and_return(true)
    allow(DsdaClient::RequestService).to receive(:new).and_return(requester)
    allow(requester).to receive(:request).and_return(response)
  end

  it 'uses the file id to only upload the file data once' do
    expect(requester).to receive(:request) do |_, _, payload|
      expect(payload['demo']['file']).not_to eq(nil)
      expect(payload['demo']['file_id']).to eq(nil)
    end.ordered.and_return(response)

    expect(requester).to receive(:request) do |_, _, payload|
      expect(payload['demo']['file']).to eq(nil)
      expect(payload['demo']['file_id']).not_to eq(nil)
    end.ordered.and_return(response)

    subject
  end
end
