# Simple benchmark to demo performance regression seen in elasticsearch index creation.

Assumes ruby 2.6.6 and bundler are installed either directly or via a ruby version manager like rbenv or rvm.

Also assumes docker for running elasticsearch

## Setup

### Installation

```
docker pull docker.elastic.co/elasticsearch/elasticsearch:5.6.16
docker pull docker.elastic.co/elasticsearch/elasticsearch:6.8.8
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.6.2
bundle install
```

## Running

Run each command in a separate terminal window

### ES 5.6.16

```
docker run --rm -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "bootstrap.memory_lock=true" -e "xpack.security.enabled=false" --ulimit "memlock=-1:-1" -e ES_JAVA_OPTS="-Xms4g -Xmx4g" docker.elastic.co/elasticsearch/elasticsearch:5.6.16
```

`bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb`

### ES 7.6.2

```
docker run --rm -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "bootstrap.memory_lock=true" -e "xpack.security.enabled=false" --ulimit "memlock=-1:-1" -e ES_JAVA_OPTS="-Xms4g -Xmx4g" docker.elastic.co/elasticsearch/elasticsearch:6.8.8
```

`bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb`

### ES 7.6.2

```
docker run --rm -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "bootstrap.memory_lock=true" -e "xpack.security.enabled=false" --ulimit "memlock=-1:-1" -e ES_JAVA_OPTS="-Xms4g -Xmx4g" docker.elastic.co/elasticsearch/elasticsearch:7.6.2
```

`bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb`

## How to read the results

each run of the script will output something like

```
Warming up --------------------------------------
   create 20 indices     1.000  i/100ms
   20 indices wait:0     1.000  i/100ms
Calculating -------------------------------------
   create 20 indices      1.018  (± 0.0%) i/s -     31.000  in  30.506013s
   20 indices wait:0      1.489  (± 0.0%) i/s -     45.000  in  30.441973s

Comparison:
   20 indices wait:0:        1.5 i/s
   create 20 indices:        1.0 i/s - 1.46x  slower
```

As more indices are created and deleted, the creation of new indices will gradually slow down and the number of iterations per second (i/s) will gradually decrease on subsequent runs.