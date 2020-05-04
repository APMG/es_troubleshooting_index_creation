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
docker run --rm -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "bootstrap.memory_lock=true" --ulimit "memlock=-1:-1"  -e "action.auto_create_index=.watches,.triggered_watches,.watcher-history-*" -e ES_JAVA_OPTS="-Xms4g -Xmx4g" -e "xpack.security.enabled=false" -e "logger.org.elasticsearch.cluster.service=TRACE" docker.elastic.co/elasticsearch/elasticsearch:5.6.16
```

`bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb`

### ES 6.8.8

```
docker run --rm -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "bootstrap.memory_lock=true" --ulimit "memlock=-1:-1" -e "action.auto_create_index=.watches,.triggered_watches,.watcher-history-*" -e ES_JAVA_OPTS="-Xms4g -Xmx4g -Xlog:disable" -e "logger.org.elasticsearch.cluster.service=TRACE" docker.elastic.co/elasticsearch/elasticsearch:6.8.8
```

`bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb && bundle exec ruby bench_es_index_mgmt.rb`

### ES 7.6.2

```
docker run --rm -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "bootstrap.memory_lock=true" --ulimit "memlock=-1:-1" -e "action.auto_create_index=.watches,.triggered_watches,.watcher-history-*" -e ES_JAVA_OPTS="-Xms4g -Xmx4g -Xlog:disable" -e "logger.org.elasticsearch.cluster.service=TRACE" docker.elastic.co/elasticsearch/elasticsearch:7.6.2
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

As more indices are created and deleted, the creation of new indices (in 6.8 and 7.2) will gradually slow down and the number of iterations per second (i/s) will gradually decrease on subsequent runs. Version 5.6 does not exhibit this behavior.

## Shell Scripts

per https://discuss.elastic.co/t/index-creation-slows-down-over-time/230775/11

There are two versions: one for linux and the other for macOS due to macOS not having gnu date installed (and therefore not supporting the `%N` format token out of the box).

The macOS one requires that you have gnu core-utils installed. Easiest way is to use `brew install core-utils`.

