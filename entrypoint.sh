#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

#service cron start

#bundle exec whenever --update-crontab # && cron -f

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
