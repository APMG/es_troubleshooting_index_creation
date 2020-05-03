require 'benchmark/ips'
require 'elasticsearch'

def client
  @client ||= Elasticsearch::Client.new(url: 'http://localhost:9200')
end

index_configs = (1..20).map do |i|
  alias_name = "test_index_#{i}"
  name = "test_#{i}_index_#{i}"
  config = {
    aliases: { alias_name => {} },
    settings: {
      number_of_shards: 1,
      number_of_replicas: 0
    }
  }

  {name: name, body: config}
end

def delete_my_indices!
  all_indices = client.indices.get_alias().keys
  my_indices = all_indices.grep(/test_/)
  client.indices.delete(index: my_indices) if my_indices.any?
end


Benchmark.ips do |x|
  # Configure the number of seconds used during
  # the warmup phase (default 2) and calculation phase (default 5)
  x.config(:time => 30, :warmup => 5)

  x.report("create 20 indices") do
    delete_my_indices!
    index_configs.each do |conf|
      client.indices.create(index: conf[:name], body: conf[:body])
    end
  end

  x.report("20 indices wait:0") do
    delete_my_indices!
    index_configs.each do |conf|
      client.indices.create(index: conf[:name], body: conf[:body], wait_for_active_shards: 0)
    end
  end

  # Compare the iterations per second of the various reports!
  x.compare!
end

# cleanup after the last run
delete_my_indices!
