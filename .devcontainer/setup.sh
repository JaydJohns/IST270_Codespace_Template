#!/bin/bash
set -e
sudo sh -c 'echo "codespace ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/codespace'
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib
sudo service postgresql start
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"