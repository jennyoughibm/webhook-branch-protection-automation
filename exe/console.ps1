#!/usr/bin/env pwsh

docker run --rm -it -e RAILS_ENV=development--name branchprotection --mount type=bind,source="$(pwd)"/branchprotection,target=/data/apps/branchprotection branchprotection:latest bundle exec rails c
