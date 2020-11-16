Example Ruby Based Kafka Sink
#####

This sink relies on Heroku Connect feeding account data into Kafka via the Heroku Streaming Data Connectors. It will pick up changes published into the stream, and create new records, or update existing records for Heroku Connect to pick up and sync into a Salesforce org.

The entire app is in `sink.rb` - and can be executed on a Heroku Dyno via `heroku ps:scale accountsync=1` after the app is deployed.

