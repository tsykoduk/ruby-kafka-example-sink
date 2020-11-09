class AccountSink < Racecar::Consumer
  subscribes_to "brave_connector_67887.salesforce.account", start_from_beginning: false

  def initialize
    puts "booting subscriber -- this is just here so I can make sure that the model is starting"
  end

  def process(message)
    puts "Processing message: #{message.value}"
    data = JSON.parse(message.value)
    
    if data.external_id__c.nil?
      puts "skipping missing External ID"
    else
      acc = Account.find_or_create_by(eternal_id__c: data.external_id__c)
    end
      
      

  end
end