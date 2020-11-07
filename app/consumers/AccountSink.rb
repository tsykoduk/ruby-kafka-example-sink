class AccountSink < Racecar::Consumer
  subscribes_to "brave_connector_67887.salesforce.account"

  def process(message)
    puts "Received message: #{message.value}"
  end
end