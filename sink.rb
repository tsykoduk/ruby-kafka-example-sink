#!/usr/bin/env ruby

ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/config/environment")

require 'rdkafka'
require 'tempfile'

kafka_brokers = ""
kak_brok = ENV.fetch('KAFKA_URL').split(",")
kaf_brok.each do k
  a = URI.parse(k)
  kafka_brokers << a.host + ":" + a.port.to_s + ","
end
kafka_brokers.delete_suffix!(",")

account_topic = ENV.fetch('ACCOUNT_TOPIC_NAME')
group_id = ENV.fetch("ACCOUNT_GROUP_ID")

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
  :"bootstrap.servers" => bootstrap_brokers,
  :"group.id" => group_id,
  :"ssl.ca.location" => tmp_ca_file.path,
  :"ssl.certificate.location" => tmp_ssl_cert.path,
  :"ssl.key.location" => tmp_ssl_key.path,
  :"security.protocol" => "ssl"
 # :"debug" => "consumer,cgrp,topic,fetch,broker"
}

consumer = Rdkafka::Config.new(config).consumer
consumer.subscribe("#{account_topic}")

consumer.each do |message|
  data = JSON.parse(message.payload)
  data.to_h
  
  acc_name = data["payload"]["after"]["name"]
  unless data["payload"]["after"]["external_id__c"]
    puts "skipping #{acc_name}"
  else
    puts "Message received - processing record #{acc_name}, id #{data["payload"]["after"]["external_id__c"]}"
    if acc = Account.find_by(external_id__c: data["payload"]["after"]["external_id__c"])  
      acc.billingcountry = data["payload"]["after"]["billingcountry"]
      acc.accountsource = data["payload"]["after"]["accountsource"]
      acc.billingpostalcode = data["payload"]["after"]["billingpostalcode"]
      acc.billingcity = data["payload"]["after"]["billingcity"]
      acc.billingstate = data["payload"]["after"]["billingstate"]
      acc.description = data["payload"]["after"]["description"]
      acc.billinglatitude = data["payload"]["after"]["billinglatitude"]
      acc.website = data["payload"]["after"]["website"]
      acc.phone = data["payload"]["after"]["phone"]
      acc.fax = data["payload"]["after"]["fax"]
      acc.billingstreet = data["payload"]["after"]["billingstreet"]
      acc.name = acc_name
      acc.billinglongitude = data["payload"]["after"]["billinglongitude"]
      acc.external_id__c = data["payload"]["after"]["external_id__c"].to_s
      acc.save!
    else
      acc = Account.new
      acc.billingcountry = data["payload"]["after"]["billingcountry"]
      acc.accountsource = data["payload"]["after"]["accountsource"]
      acc.billingpostalcode = data["payload"]["after"]["billingpostalcode"]
      acc.billingcity = data["payload"]["after"]["billingcity"]
      acc.billingstate = data["payload"]["after"]["billingstate"]
      acc.description = data["payload"]["after"]["description"]
      acc.billinglatitude = data["payload"]["after"]["billinglatitude"]
      acc.website = data["payload"]["after"]["website"]
      acc.phone = data["payload"]["after"]["phone"]
      acc.fax = data["payload"]["after"]["fax"]
      acc.billingstreet = data["payload"]["after"]["billingstreet"]
      acc.name = acc_name
      acc.billinglongitude = data["payload"]["after"]["billinglongitude"]
      acc.external_id__c = data["payload"]["after"]["external_id__c"].to_s
      acc.save!
    end
    puts "************ saved account #{Account.find_by(external_id__c: data["payload"]["after"]["external_id__c"]).name} with id #{Account.find_by(external_id__c: data["payload"]["after"]["external_id__c"]).external_id__c}"
  end
end




