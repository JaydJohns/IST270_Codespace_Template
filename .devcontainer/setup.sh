#!/bin/bash
#
# This script waits for the PostgreSQL database container to be ready
# and then prints the connection details.
#

echo "🚀 Starting environment setup..."
echo "Waiting for the local PostgreSQL database to be ready."
echo "This may take a moment..."

echo "Checking database status..."

# Loop until pg_isready returns 0 (success)
# We point it to localhost because Postgres runs inside this Codespace.
until pg_isready -U postgres -h localhost -q; do
  printf "."
  sleep 1
done

echo "\n\n✅ Success! The PostgreSQL database is running and ready for connections."
echo ""
echo "--- Connection Details ---"
echo "Host:     localhost"
echo "Database: appdb"
echo "User:     postgres"
echo "Password: postgres"
echo "Port:     5432"
echo "--------------------------"
echo "\nYou can now use the VS Code PostgreSQL extension (the elephant icon) to connect."
echo "Right-click 'Databases' > 'Add Connection' and use the details above."
