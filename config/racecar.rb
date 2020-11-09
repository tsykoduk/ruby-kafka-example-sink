Racecar.configure do |config|
  # Each config variable can be set using a writer attribute.
  config.brokers = ServiceDiscovery.find("kafka-brokers")
end