require 'spec_helper'
require 'dsda_client/options'
require 'dsda_client/request_service'

RSpec.describe DsdaClient::RequestService do
  let(:options) do
    instance_double(
      DsdaClient::Options,
      post?: true,
      production?: false,
      dump_requests?: false
    )
  end

  let(:service) { described_class.new(options) }

  describe '#request' do
    subject(:request) { service.request(uri, headers, '') }

    let(:uri) { URI('http://0.0.0.0:3000') }
    let(:headers) { { 'username': 'gandalf' } }

    it 'makes a request' do
      allow(service).to receive(:request_failure).and_return(nil)
      expect(Net::HTTP).to receive(:start).with(uri.hostname, uri.port, anything)
      request
    end

    context 'request failure' do
      let(:response) { instance_double(Net::HTTPUnprocessableEntity, code: 422) }

      it 'logs the error' do
        allow(service).to receive(:make_request).and_return(response)
        expect(DsdaClient::Terminal).to receive(:error)
        request
      end
    end

    context 'request success' do
      let(:body) { '{ "id": 3 }' }
      let(:response_hash) { { 'id' => 3 } }
      let(:response) { Net::HTTPSuccess.new(1, 201, '') }

      it 'logs the response hash' do
        allow(response).to receive(:body).and_return(body)
        allow(service).to receive(:make_request).and_return(response)
        expect(DsdaClient::Terminal).to receive(:pretty_json).with(response_hash)
        request
      end
    end
  end
end
