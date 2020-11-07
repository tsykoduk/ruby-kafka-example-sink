#!/usr/bin/env ruby

ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/config/environment")

# for Kafka message reading
require 'rdkafka'


kafka_config = { 
  "bootstrap.servers": ENV['KAFKA_URL'], 
  "group.id": "sushi-sink"
}


#accounts_sink
accounts_topic = "brave_connector_67887.salesforce.account"

accounts_consumer = Rdkafka::Config.new(kafka_config).consumer

accounts_consumer.subscribe(accounts_topic)

#the meat
accounts_consumer.each do |message|
  puts "Message received: #{message}"
end