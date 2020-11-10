#!/usr/bin/env ruby

ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/config/environment")

require 'rdkafka'
require 'tempfile'

tmp_ca_file = Tempfile.new('ca_certs')
tmp_ca_file.write(ENV.fetch('KAFKA_TRUSTED_CERT'))
tmp_ca_file.close
tmp_ssl_cert = Tempfile.new('kakfa_cert')
tmp_ssl_cert.write(ENV.fetch('KAFKA_CLIENT_CERT'))
tmp_ssl_cert.close
tmp_ssl_key = Tempfile.new('kakfa_cert_key')
tmp_ssl_key.write(ENV.fetch('KAFKA_CLIENT_CERT_KEY'))
tmp_ssl_key.close

config = {
  :"bootstrap.servers" => "ec2-34-193-50-177.compute-1.amazonaws.com:9096,ec2-54-221-245-252.compute-1.amazonaws.com:9096,ec2-54-86-66-15.compute-1.amazonaws.com:9096",
  :"group.id" => "ruby-test",
  :"ssl.ca.location" => tmp_ca_file.path,
  :"ssl.certificate.location" => tmp_ssl_cert.path,
  :"ssl.key.location" => tmp_ssl_key.path,
  :"security.protocol" => "ssl"
 # :"debug" => "consumer,cgrp,topic,fetch,broker"
}

consumer = Rdkafka::Config.new(config).consumer
consumer.subscribe("independent_connector_7719.salesforce.account")

consumer.each do |message|
  data = JSON.parse(message.payload)
  data.to_h
  
  acc_name = data["payload"]["after"]["name"]
  acc_id = data["payload"]["after"]["external_id__c"]

  puts "Message received - processing record #{acc_name}"

  if acc_id == ""
    puts "skipping -- missing External ID for record #{acc_name}"
  else
    acc = Account.find_or_create_by(external_id__c: acc_id)  
    acc.billingcountry = data["payload"]["after"]["billingcountry"]
    acc.accountsource = data["payload"]["after"]["accountsource"]
    acc.billingpostalcode = data["payload"]["after"]["billingpostalcode"]
    acc.billingcity = data["payload"]["after"]["billingpostalcode"]
    acc.billingstate = data["payload"]["after"]["billingstate"]
    acc.description = data["payload"]["after"]["description"]
    acc.billinglatitude = data["payload"]["after"]["billinglatitude"]
    acc.website = data["payload"]["after"]["website"]
    acc.phone = data["payload"]["after"]["phone"]
    acc.fax = data["payload"]["after"]["fax"]
    acc.billingstreet = data["payload"]["after"]["billingstreet"]
    acc.name = acc_name
    acc.billinglongitude = data["payload"]["after"]["billinglongitude"]
    acc.external_id__c = data["payload"]["after"]["external_id__c"]
    acc.save
    puts "saved account " + acc.name
  end
end




