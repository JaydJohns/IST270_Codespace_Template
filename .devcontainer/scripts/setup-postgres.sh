#!/usr/bin/env bash
set -euo pipefail

echo "[setup-postgres] Installing PostgreSQL server and tools..."
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  postgresql postgresql-contrib postgresql-client

echo "[setup-postgres] PostgreSQL installed. A default cluster is usually created by Debian packages."
echo "[setup-postgres] Installation complete."
