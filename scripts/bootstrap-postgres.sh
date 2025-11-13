#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETUP_SCRIPT="${ROOT_DIR}/.devcontainer/scripts/setup-postgres.sh"
START_SCRIPT="${ROOT_DIR}/.devcontainer/scripts/start-postgres.sh"
PG_EXTENSION="ms-ossdata.vscode-pgsql"

echo "IST270 Codespace manual database bootstrap"
echo "-------------------------------------------"
echo "This script will:"
echo "  1. Install PostgreSQL server/client packages."
echo "  2. Start the local cluster, set the postgres password, and create '${POSTGRES_DB:-appdb}'."
echo "  3. Install the VS Code PostgreSQL extension (${PG_EXTENSION})."
echo ""
read -r -p "Continue? [y/N] " REPLY
if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
  echo "Aborting setup."
  exit 0
fi

echo ""
echo "[manual] Installing PostgreSQL packages..."
env POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}" POSTGRES_DB="${POSTGRES_DB:-appdb}" bash "${SETUP_SCRIPT}"

echo ""
echo "[manual] Starting PostgreSQL and applying defaults..."
env POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}" POSTGRES_DB="${POSTGRES_DB:-appdb}" bash "${START_SCRIPT}"

if command -v code >/dev/null 2>&1; then
  echo ""
  echo "[manual] Installing VS Code extension '${PG_EXTENSION}'..."
  if code --install-extension "${PG_EXTENSION}" >/dev/null; then
    echo "[manual] Extension installed (or already present)."
  else
    echo "[manual] Warning: failed to install extension automatically. You can install it from the VS Code Extensions panel."
  fi
else
  echo ""
  echo "[manual] 'code' CLI not found; please install the VS Code PostgreSQL extension manually."
fi

echo ""
echo "[manual] PostgreSQL bootstrap complete."
echo "        Connect with: host=localhost user=postgres password=${POSTGRES_PASSWORD:-postgres} db=${POSTGRES_DB:-appdb} port=5432"
