#!/bin/bash

set -euo pipefail

curl -s -XDELETE 'http://localhost:9200/test_*' > /dev/null

while true
do
  start=$(gdate +%s%N)

  for i in $(seq 10 30)
  do
    curl -s -XPUT 'http://localhost:9200/test_'$i -H 'Content-type: application/json' --data-binary $'{"settings":{"number_of_shards":1,"number_of_replicas":0}}' > /dev/null
  done

  curl -s -XDELETE 'http://localhost:9200/test_*' > /dev/null

  end=$(gdate +%s%N)

  duration=$((($end-$start)/1000000))
  echo "Duration: $duration ms"
done