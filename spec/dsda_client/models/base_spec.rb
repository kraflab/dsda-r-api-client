require 'spec_helper'
require 'dsda_client/models/base'

RSpec.describe DsdaClient::Models::Base do
  class Klass < described_class
    require_keys 'author', 'title', ['file', 'file_id']
    allow_keys 'year', 'protagonist'
    require_otp
  end

  before do
    allow(DsdaClient::Options).to receive(:otp).and_return(otp)
  end

  let(:otp) { 'otp' }

  describe '.valid?' do
    let(:valid_hash) do
      {
        'author'      => 'ray bradbury',
        'title'       => 'dandelion wine',
        'year'        => 1957,
        'protagonist' => 'douglas',
        'file_id'     => '1234'
      }
    end

    subject(:valid) { Klass.valid?(hash) }

    context 'missing required key' do
      let(:hash) { valid_hash.except('title') }

      it { expect(valid).to eq(false) }
    end

    context 'includes disallowed key' do
      let(:hash) { valid_hash.merge('foo' => 'bar') }

      it { expect(valid).to eq(false) }
    end

    context 'has all required keys and no disallowed keys' do
      let(:hash) { valid_hash }

      it { expect(valid).to eq(true) }

      context 'when missing the otp' do
        let(:otp) { nil }

        it { is_expected.to eq(false) }
      end
    end
  end

  describe '.invalid?' do
    context 'instance is valid' do
      before { allow(Klass).to receive(:valid?).and_return(true) }

      it { expect(Klass.invalid?({})).to eq(false) }
    end

    context 'instance is invalid' do
      before { allow(Klass).to receive(:valid?).and_return(false) }

      it { expect(Klass.invalid?({})).to eq(true) }
    end
  end
end
