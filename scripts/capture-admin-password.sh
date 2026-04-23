#!/usr/bin/env bash
set -euo pipefail

OUTPUT_FILE="${OUTPUT_FILE:-./ttrss_admin_password.txt}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-30}"
SLEEP_SECONDS="${SLEEP_SECONDS:-2}"

if [[ -f "${OUTPUT_FILE}" ]] && grep -q '^TTRSS_ADMIN_PASSWORD=' "${OUTPUT_FILE}"; then
  echo "Admin password file already exists: ${OUTPUT_FILE}"
  exit 0
fi

attempt=1
password=""

while (( attempt <= MAX_ATTEMPTS )); do
  password="$(
    docker compose logs app 2>/dev/null | sed -n "s/.*Setting initial built-in admin user password to '\\([^']\\+\\)'.*/\\1/p" | tail -n 1
  )"

  if [[ -n "${password}" ]]; then
    break
  fi

  sleep "${SLEEP_SECONDS}"
  ((attempt++))
done

if [[ -z "${password}" ]]; then
  echo "WARNING: Could not capture TTRSS admin password from container logs."
  exit 0
fi

cat >"${OUTPUT_FILE}" <<EOF
TTRSS_ADMIN_USER=admin
TTRSS_ADMIN_PASSWORD=${password}
EOF

chmod 600 "${OUTPUT_FILE}"
echo "Saved TTRSS admin password to ${OUTPUT_FILE}"
