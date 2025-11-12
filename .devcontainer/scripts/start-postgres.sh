#!/usr/bin/env bash
set -euo pipefail

POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-appdb}"

echo "[start-postgres] Starting PostgreSQL service/cluster..."

# Try starting via pg_ctlcluster if available (Debian/Ubuntu)
if command -v pg_lsclusters >/dev/null 2>&1; then
  LINE=$(pg_lsclusters | awk 'NR==2{print $1, $2}') || true
  if [[ -n "${LINE:-}" ]]; then
    # shellcheck disable=SC2086
    sudo pg_ctlcluster --skip-systemctl-redirect $LINE start || true
  fi
fi

# Fallback to service command
sudo service postgresql start || true

echo "[start-postgres] Waiting for server to become ready..."
for i in {1..30}; do
  if sudo -u postgres pg_isready -q; then
    break
  fi
  sleep 1
done

if ! sudo -u postgres pg_isready -q; then
  echo "[start-postgres] Warning: PostgreSQL did not report ready state; continuing anyway."
fi

echo "[start-postgres] Setting default postgres user password..."
sudo -u postgres psql -v ON_ERROR_STOP=1 -tAc "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';" || true

echo "[start-postgres] Ensuring database '${POSTGRES_DB}' exists..."
sudo -u postgres psql -v ON_ERROR_STOP=1 -tAc "SELECT 1 FROM pg_database WHERE datname='${POSTGRES_DB}'" | grep -q 1 || \
  sudo -u postgres createdb "${POSTGRES_DB}" || true

echo "[start-postgres] Done. Connection string example: postgres://postgres:${POSTGRES_PASSWORD}@localhost:5432/${POSTGRES_DB}"
