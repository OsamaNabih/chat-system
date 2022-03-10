# config = {
#   #host: "http://localhost:9200/",
#   host: "http://172.20.128.2:9200/",
#   transport_options: {
#     request: { timeout: 5 }
#   }
# }

# puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!initializing es!!!!!!!!!!!!!!!!!!!!!!!!"

# if File.exists?("config/elasticsearch.yml")
#   config.merge!(YAML.load_file("config/elasticsearch.yml")[Rails.env].deep_symbolize_keys)
# end



# Elasticsearch::Client.new(host: config[:host])


#Elasticsearch::Model.client = Elasticsearch::Client.new(config)