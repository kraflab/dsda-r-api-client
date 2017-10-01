#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib/dsda_client/options'
require 'lib/dsda_client/api'
require 'lib/dsda_client/command_parser'
require 'lib/dsda_client/terminal'

options        = DsdaClient::Options.new(ARGV)
root_uri       = DsdaClient::Api.location
command_parser = DsdaClient::CommandParser.new(root_uri, options)

DsdaClient::Terminal.run(command_parser)
