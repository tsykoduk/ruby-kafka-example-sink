class AccountSink < Racecar::Consumer
  subscribes_to "brave_connector_67887.salesforce.account", start_from_beginning: false

  def initialize
    puts "booting subscriber -- this is just here so I can make sure that the model is starting"
  end

  def process(message)
    puts "we got a message!"
    puts "Processing message: #{message}"
    data = JSON.parse(message.value)
    
    if data.external_id__c.nil?
      puts "skipping missing External ID"
    else
      acc = Account.find_or_create_by(eternal_id__c: data.external_id__c)
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
    end
      
      

  end
end