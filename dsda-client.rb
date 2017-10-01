#!/usr/bin/env ruby

require_relative 'lib/extensions'
require_relative 'lib/helper'
require_relative 'lib/dsda_client/options'
require_relative 'lib/dsda_client/command_parser'
require_relative 'lib/dsda_client/terminal'

options        = DsdaClient::Options.new(ARGV)
root_uri       = DsdaClient::Api.location
command_parser = DsdaClient::CommandParser.new(root_uri, options)

DsdaClient::Terminal.run(command_parser)
