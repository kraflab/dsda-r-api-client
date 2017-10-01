#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.dirname(__FILE__).join('/lib'))
require 'dsda_client/options'
require 'dsda_client/api'
require 'dsda_client/command_parser'
require 'dsda_client/terminal'

options        = DsdaClient::Options.new(ARGV)
root_uri       = DsdaClient::Api.location
command_parser = DsdaClient::CommandParser.new(root_uri, options)

DsdaClient::Terminal.run(command_parser)
