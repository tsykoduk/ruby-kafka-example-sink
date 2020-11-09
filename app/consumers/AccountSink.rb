class AccountSink < Racecar::Consumer
  subscribes_to "brave_connector_67887.salesforce.account", start_from_beginning: false

  def process(message)
    puts "Processing message: #{message.value}"
    data = JSON.parse(message.value)
    puts data
    puts "hello, is this working?"

  end
end