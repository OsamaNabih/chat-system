#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
rails server -p 3000 -b 0.0.0.0