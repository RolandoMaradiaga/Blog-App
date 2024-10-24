#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Execute the container's main process (as defined in the Dockerfile CMD).
exec "$@"
