#!/bin/bash

SLEEP=${SLEEP:-600}
if [ -n "$1" ]; then
  echo "Running $@"
  exec "$@"
else
  echo "Running update-ipset -s"
  while true; do
    update-ipsets -s
    echo "Going to sleep for $SLEEP seconds..."
    sleep $SLEEP
  done
fi

