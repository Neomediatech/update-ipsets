#!/bin/bash

SLEEP=${SLEEP:-600}
OPTS=""
if [ -n "$1" ]; then
  echo "Running $@"
  exec "$@"
else
  if [ -f /data/etc/update-ipsets.conf ]; then
    OPTS="-f /data/etc/update-ipsets.conf"
  fi
  if [ -n "ENV_CONFIGFILE" ]; then
    OPTS="-f $ENV_CONFIGFILE"
  fi
  echo "Running update-ipset -s $OPTS"
  while true; do
    update-ipsets -s $OPTS
    RANDOM_SLEEP=$(($RANDOM % 20 + $((SLEEP / 10)) * 10))
    echo "Going to sleep for $RANDOM_SLEEP seconds..."
    sleep $RANDOM_SLEEP
  done
fi

