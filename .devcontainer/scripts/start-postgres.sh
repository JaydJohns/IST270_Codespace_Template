#!/usr/bin/env bash
set -euo pipefail

POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-appdb}"

echo "[start-postgres] Starting PostgreSQL service/cluster..."

start_cluster() {
  local version="$1"
  local name="$2"
  echo "[start-postgres]   -> starting cluster ${version}/${name}"
  sudo pg_ctlcluster --skip-systemctl-redirect "${version}" "${name}" start || true
}

if command -v pg_lsclusters >/dev/null 2>&1; then
  CLUSTERS=()
  while read -r ver name _; do
    [[ -n "${ver:-}" && -n "${name:-}" ]] && CLUSTERS+=("${ver}:${name}")
  done < <(pg_lsclusters 2>/dev/null | awk 'NR>1 {print $1 ":" $2}' || true)

  if [[ ${#CLUSTERS[@]} -eq 0 ]]; then
    echo "[start-postgres] No clusters found; creating default one."
    default_ver=$(psql -V 2>/dev/null | awk '{print $3}' | cut -d. -f1 || true)
    default_ver=${default_ver:-16}
    sudo pg_createcluster "${default_ver}" main --start || true
  else
    for cluster in "${CLUSTERS[@]}"; do
      start_cluster "${cluster%%:*}" "${cluster##*:}"
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
