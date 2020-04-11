require 'spec_helper'
require 'dsda_client/token_manager'

RSpec.describe DsdaClient::TokenManager do
  describe '.get_token' do
    subject { described_class.get_token }

    let(:existing_token) { 'foo-token' }
    let(:username) { 'rodney' }
    let(:password) { 'mullen' }
    let(:location) { "https://test.example.com/api" }
    let(:file_data) { "#{existing_token}\n#{expiration_time}" }
    let(:request_service) { instance_double(DsdaClient::RequestService) }
    let(:uri) { URI(location + '/tokens') }
    let(:payload) { { username: username, password: password } }
    let(:response) { { 'token' => response_token, 'exp' => response_exp } }
    let(:expiration_time) { 1.day.from_now.to_i }
    let(:file_exists) { true }
    let(:response_token) { 'new-token' }
    let(:response_exp) { 7.days.from_now.to_i }

    before do
      allow(File).to receive(:exists?).with('.token')
        .and_return(file_exists)
      allow(File).to receive(:read).with('.token')
        .and_return(file_data)
      allow(File).to receive(:write)
      allow(DsdaClient::Api).to receive(:password).and_return(password)
      allow(DsdaClient::Api).to receive(:username).and_return(username)
      allow(DsdaClient::Api).to receive(:location).and_return(location)
      allow(DsdaClient::RequestService).to receive(:new)
        .and_return(request_service)
      allow(request_service).to receive(:request).with(uri, {}, payload)
        .and_return(response)
    end

    context 'when a token file exists' do
      let(:file_exists) { true }

      context 'when the expiration time is in the future' do
        let(:expiration_time) { 1.day.from_now.to_i }

        it { is_expected.to eq(existing_token) }
      end

      context 'when the expiration time is close' do
        let(:expiration_time) { 5.minutes.from_now.to_i }

        it { is_expected.to eq(response_token) }

        it 'stores the token for later' do
          expect(File).to receive(:write).with(
            '.token',
            "#{response_token} #{response_exp}"
          )
          subject
        end
      end
    end

    context 'when a token file does not exist' do
      let(:file_exists) { false }

      it { is_expected.to eq(response_token) }

      it 'stores the token for later' do
        expect(File).to receive(:write).with(
          '.token',
          "#{response_token} #{response_exp}"
        )
        subject
      end
    end
  end
end
