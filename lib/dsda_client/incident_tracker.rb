require 'dsda_client/terminal'

module DsdaClient
  class IncidentTracker
    class << self
      def track(event_type, model, obj)
        @incidents ||= {}
        @incidents[event_type] ||= {}
        @incidents[event_type][model] ||= []
        @incidents[event_type][model] << obj
      end

      def dump
        return unless @incidents

        DsdaClient::Terminal.log_error(@incidents)
      end
    end
  end
end
