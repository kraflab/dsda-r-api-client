#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'dsda_client/options'
require 'dsda_client/api'
require 'dsda_client/command_parser'
require 'dsda_client/terminal'
require 'dsda_client/incident_tracker'

options        = DsdaClient::Options.setup(ARGV)
root_uri       = DsdaClient::Api.location
command_parser = DsdaClient::CommandParser.new(root_uri, options)

DsdaClient::Terminal.run(command_parser, ARGF.read)
DsdaClient::IncidentTracker.dump
