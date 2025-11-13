#!/usr/bin/env bash
set -euo pipefail

POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-appdb}"

echo "[start-postgres] Starting PostgreSQL service/cluster..."

if ! command -v sudo >/dev/null 2>&1; then
  echo "[start-postgres] Error: sudo is required inside the container."
  exit 1
fi

if ! sudo -n true 2>/dev/null; then
  echo "[start-postgres] Error: sudo requires a password in this environment. Please enable passwordless sudo or run the script as root."
  exit 1
fi

SUDO="sudo -n"

run_root() {
  $SUDO "$@"
}

run_postgres() {
  $SUDO -u postgres "$@"
}

start_cluster() {
  local version="$1"
  local name="$2"
  echo "[start-postgres]   -> starting cluster ${version}/${name}"
  run_root pg_ctlcluster --skip-systemctl-redirect "${version}" "${name}" start || true
}

if command -v pg_lsclusters >/dev/null 2>&1; then
  mapfile -t CLUSTERS < <(pg_lsclusters 2>/dev/null | awk 'NR>1 {print $1 ":" $2}' || true)

  if [[ ${#CLUSTERS[@]} -eq 0 ]]; then
    echo "[start-postgres] No clusters found; creating default one."
    default_ver=$(psql -V 2>/dev/null | awk '{print $3}' | cut -d. -f1 || true)
    default_ver=${default_ver:-16}
    run_root pg_createcluster "${default_ver}" main --start || true
  else
    for cluster in "${CLUSTERS[@]}"; do
      ver="${cluster%%:*}"
      name="${cluster##*:}"
      [[ -n "${ver}" && -n "${name}" ]] && start_cluster "${ver}" "${name}"
    done
  fi
else
  echo "[start-postgres] pg_lsclusters not available; cannot start PostgreSQL automatically."
fi

if [[ ! -d /run/systemd/system ]]; then
  echo "[start-postgres] Notice: systemd/service start skipped (not available in this container)."
fi

echo "[start-postgres] Waiting for server to become ready..."
for i in {1..30}; do
  if run_postgres pg_isready -q; then
    break
  fi
  sleep 1
done

if ! run_postgres pg_isready -q; then
  echo "[start-postgres] Warning: PostgreSQL did not report ready state; continuing anyway."
fi

echo "[start-postgres] Setting default postgres user password..."
run_postgres psql -v ON_ERROR_STOP=1 -tAc "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';" || true

echo "[start-postgres] Ensuring database '${POSTGRES_DB}' exists..."
run_postgres psql -v ON_ERROR_STOP=1 -tAc "SELECT 1 FROM pg_database WHERE datname='${POSTGRES_DB}'" | grep -q 1 || \
  run_postgres createdb "${POSTGRES_DB}" || true

echo "[start-postgres] Done. Connection string example: postgres://postgres:${POSTGRES_PASSWORD}@localhost:5432/${POSTGRES_DB}"
