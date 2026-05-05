#!/usr/bin/env bash
set -euo pipefail

if [[ -f ".env.local" ]]; then
  set -a
  # shellcheck disable=SC1091
  source ".env.local"
  set +a
fi

DATA_DIR="${1:-${HOST_DATA_DIR:-./data}}"
APP_DIR="${TTRSS_APP_DIR:-${DATA_DIR}/ttrss_app}"
DB_DIR="${TTRSS_DB_DIR:-${DATA_DIR}/ttrss_db}"
CONFIG_DIR="${TTRSS_CONFIG_DIR:-${DATA_DIR}/config.d}"

mkdir -p "${APP_DIR}" "${CONFIG_DIR}" "${DB_DIR}"

echo "Initialized TTRSS data directories under: ${DATA_DIR}"
