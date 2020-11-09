class AccountSinkConsumer < Racecar::Consumer
  subscribes_to "brave_connector_67887\.salesforce\.account"

  def process(message)
    puts "Received message: #{message.value}"
  end
  
  
rescue JSON::ParserError => e
  puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  # It's probably a good idea to report the exception to an exception tracker service.
end
