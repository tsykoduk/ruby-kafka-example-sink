class AccountSinkConsumer < Racecar::Consumer
  subscribes_to "brave_connector_67887.salesforce.account", start_from_beginning: false
  
  puts "starting up"

  def process(message)
    puts "Processing a message!"
    puts "Received message: #{message.value}"
  
    data = JSON.parse(message.value)
  
    if data.external_id__c.nil?
      puts "skipping missing External ID"
    else
      acc = Account.find_or_create_by(external_id__c: data.external_id__c)
      acc.billingcountry = data.billingcountry
      acc.accountsource = data.accountsource
      acc.billingpostalcode = data.billingpostalcode
      acc.billingcity = data.billingpostalcode
      acc.billingstate = data.billingstate
      acc.description = data.description
      acc.billinglatitude = data.billinglatitude
      acc.website = data.website
      acc.phone = data.website
      acc.fax = data.fax
      acc.billingstreet = data.fax
      acc.name = data.name
      acc.billinglongitude = data.billinglongitude
      acc.save
      puts "saved account " + acc.name
    end
  end
  
rescue JSON::ParserError => e
  puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  # It's probably a good idea to report the exception to an exception tracker service.
end
