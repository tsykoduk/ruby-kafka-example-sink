class AccountSink < Racecar::Consumer
  subscribes_to "brave_connector_67887.salesforce.account"

  def process(message)
    puts "Processing message: #{message.value}"
    data = JSON.parse(message.value)
    puts data

  end
end