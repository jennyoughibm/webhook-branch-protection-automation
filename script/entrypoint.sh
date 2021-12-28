#!/bin/bash
set -e

cp /data/apps/branchprotection/.bundle/config /usr/local/bundle/config

exec "$@"
