#!/bin/bash

SLEEP=${SLEEP:-600}
if [ -n "$1" ]; then
  echo "Running $@"
  exec "$@"
else
  echo "Running update-ipset -s"
  while true; do
    update-ipsets -s
    RANDOM_SLEEP=$(($RANDOM % 20 + $((SLEEP / 10)) * 10))
    echo "Going to sleep for $RANDOM_SLEEP seconds..."
    sleep $RANDOM_SLEEP
  done
fi

