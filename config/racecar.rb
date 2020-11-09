kakfa_brokers = "ec2-34-193-50-177.compute-1.amazonaws.com:9096,ec2-54-221-245-252.compute-1.amazonaws.com:9096,ec2-54-86-66-15.compute-1.amazonaws.com:9096"

Racecar.configure do |config|
  # Each config variable can be set using a writer attribute.
  config.brokers = ServiceDiscovery.find("#{kafka_brokers}")
end