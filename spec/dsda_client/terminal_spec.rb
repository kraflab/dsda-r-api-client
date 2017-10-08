require 'spec_helper'
require 'dsda_client/terminal'

RSpec.describe DsdaClient::Terminal do
  describe '.run' do
    let(:command_parser) { double }
    let(:input)     { '{ "demo": { "player": "elim"} }' }
    let(:data_hash) { { 'demo' => { 'player' => 'elim' } } }

    it 'passes parsed input to command parser' do
      expect(command_parser).to receive(:parse).with(data_hash)
      described_class.run(command_parser, input)
    end
  end

  let(:text) { 'hello' }
  let(:success_text) {
    described_class::SUCCESS_CODE + text + described_class::END_CODE
  }
  let(:error_text) {
    described_class::ERROR_CODE + text + described_class::END_CODE
  }

  describe '.success' do
    it 'prints out coloured text' do
      expect(STDOUT).to receive(:puts).with(success_text)
      described_class.success(text)
    end
  end

  describe '.error' do
    it 'prints out coloured text' do
      expect(STDOUT).to receive(:puts).with(error_text)
      described_class.error(text)
    end
  end

  describe '.bracket_success' do
    it 'prints out success text wrapped in brackets' do
      expect(STDOUT).to receive(:puts).with('[ ' + success_text + ' ]')
      described_class.bracket_success(text)
    end
  end

  describe '.bracket_error' do
    it 'prints out error text wrapped in brackets' do
      expect(STDOUT).to receive(:puts).with('[ ' + error_text + ' ]')
      described_class.bracket_error(text)
    end
  end

  let(:raw_data) { { file: { name: 'data', data: '1234' } } }
  let(:pruned_data) { { file: { name: 'data', data: '[pruned]' } } }

  describe '.log_error' do
    it 'logs a pruned json to stderr' do
      expect(STDERR).to receive(:puts).with(JSON.pretty_generate(pruned_data))
      described_class.log_error(raw_data)
    end
  end

  describe '.pretty_json' do
    it 'prints pretty json' do
      expect(STDOUT).to receive(:puts)
        .with(JSON.pretty_generate(raw_data).gsub(/"/,''))
      described_class.pretty_json(raw_data)
    end
  end
end
