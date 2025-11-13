#!/bin/bash
#
# This script waits for the PostgreSQL database container to be ready
# and then prints the connection details.
#

echo "🚀 Starting environment setup..."
echo "Waiting for the PostgreSQL database (service name 'db') to be ready."
echo "This may take a moment..."

# We will use the 'pg_isready' command, which is part of the postgresql-client.
# First, let's make sure that tool is installed in our app container.
sudo apt-get update > /dev/null && sudo apt-get install -y postgresql-client > /dev/null

echo "Checking database status..."

# Loop until pg_isready returns 0 (success)
# We point it to the host 'db' (the name of our database service)
until pg_isready -U postgres -h db -q; do
  printf "."
  sleep 1
done

echo "\n\n✅ Success! The PostgreSQL database is running and ready for connections."
echo ""
echo "--- Connection Details ---"
echo "Host:     db"
echo "Database: assignment_db"
echo "User:     postgres"
echo "Password: password"
echo "Port:     5432"
echo "--------------------------"
echo "\nYou can now use the VS Code PostgreSQL extension (the elephant icon) to connect."
echo "Right-click 'Databases' > 'Add Connection' and use the details above."