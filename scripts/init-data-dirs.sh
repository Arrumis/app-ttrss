#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${1:-${HOST_DATA_DIR:-./data}}"

mkdir -p "${DATA_DIR}/app" "${DATA_DIR}/config.d" "${DATA_DIR}/db"

echo "Initialized TTRSS data directories under: ${DATA_DIR}"

