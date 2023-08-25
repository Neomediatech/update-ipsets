#!/bin/bash

[ ! -d /data/ipsets/web ] && mkdir -p /data/ipsets/web

exec "$@"
