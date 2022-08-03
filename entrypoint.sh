#!/bin/bash
set -e

bundle install

# Remove a potentially pre-existing server.pid for Rails.
rm -f /ceap/tmp/pids/server.pid

echo ""
echo "   .     '     ,"
echo "     _________"
echo "  _ /_|_____|_\ _"
echo "    '. \   / .'"
echo "      '.\ /.'"
echo "        '.'"
echo " "
echo ""
echo ""

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
