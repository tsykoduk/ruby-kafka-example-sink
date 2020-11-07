#!/usr/bin/env ruby

ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/config/environment")

# for Kafka message reading
require 'racecar'

topic = "brave_connector_67887.salesforce.account"


class AccountSink < Racecar::Consumer
  subscribes_to "brave_connector_67887.salesforce.account"

  def process(message)
    puts message
  end
end