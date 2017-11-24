require 'spec_helper'
require 'dsda_client/incident_tracker'

describe DsdaClient::IncidentTracker do
  let(:obj) do
    {
      name: 'hello',
      username: 'hello_again'
    }
  end
  let(:model) { :demo }
  let(:event_type) { :invalid }
  let(:incidents) { described_class.instance_variable_get(:@incidents) }

  describe '.track' do
    it 'stores the given content' do
      described_class.track(event_type, model, obj)
      expect(incidents[event_type][model]).to eq([obj])
    end
  end

  describe '.dump' do
    it 'sends the data to the terminal' do
      described_class.track(event_type, model, obj)
      expect(DsdaClient::Terminal).to receive(:log_error).with(incidents)
      described_class.dump
    end
  end
end
