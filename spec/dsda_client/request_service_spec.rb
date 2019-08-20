require 'spec_helper'
require 'dsda_client/options'
require 'dsda_client/request_service'

RSpec.describe DsdaClient::RequestService do
  let(:options) do
    instance_double(
      DsdaClient::Options,
      production?: false,
      dump_requests?: false
    )
  end
  let(:uri) { URI('http://0.0.0.0:3000') }
  let(:headers) { { 'username': 'gandalf' } }
  let(:service) { described_class.new(options) }
  let(:response) do
    instance_double(
      Net::HTTPSuccess,
      body: body,
      code: '201'
    )
  end
  let(:body) { '{"save":true,"demo":{"id":13,"file_id":10},"error":false,"error_message":[]}' }

  subject(:request) { service.request(uri, headers, '') }

  before do
    allow(Net::HTTP).to receive(:start).and_return(response)
  end

  it 'makes a request' do
    allow(service).to receive(:request_failure).and_return(nil)
    expect(Net::HTTP).to receive(:start).with(uri.hostname, uri.port, anything)
    request
  end

  context 'request failure' do
    let(:response) do
      instance_double(
        Net::HTTPUnprocessableEntity,
        body: body,
        code: '422'
      )
    end

    it 'logs the error' do
      expect(DsdaClient::Terminal).to receive(:error)
      request
    end
  end

  context 'request success' do
    let(:response_hash) { JSON.parse(body) }

    it 'logs the response hash' do
      expect(DsdaClient::Terminal).to receive(:pretty_json)
        .with(response_hash.except('error', 'error_message'))
      request
    end

    it 'returns the response' do
      expect(request).to eq(response_hash)
    end
  end
end
