tmp_ca_file = Tempfile.new('ca_certs')
tmp_ca_file.write(ENV.fetch('KAFKA_TRUSTED_CERT'))
tmp_ca_file.close
tmp_ssl_cert = Tempfile.new('kakfa_cert')
tmp_ssl_cert.write(ENV.fetch('KAFKA_CLIENT_CERT'))
tmp_ssl_cert.close
tmp_ssl_key = Tempfile.new('kakfa_cert_key')
tmp_ssl_key.write(ENV.fetch('KAFKA_CLIENT_CERT_KEY'))
tmp_ssl_key.close

Racecar.configure do |config|
  # Each config variable can be set using a writer attribute.
  config.brokers = ServiceDiscovery.find("ec2-34-193-50-177.compute-1.amazonaws.com:9096,ec2-54-221-245-252.compute-1.amazonaws.com:9096,ec2-54-86-66-15.compute-1.amazonaws.com:9096")
  group.id = "ruby-test",
  ssl.ca.location = tmp_ca_file.path,
  ssl.certificate.location =tmp_ssl_cert.path,
  ssl.key.location = tmp_ssl_key.path,
  security.protocol = ssl
end