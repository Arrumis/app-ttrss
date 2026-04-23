#!/usr/bin/env bash
set -euo pipefail

OUTPUT_FILE="${OUTPUT_FILE:-./ttrss_admin_password.txt}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-30}"
SLEEP_SECONDS="${SLEEP_SECONDS:-2}"

if [[ -f "${OUTPUT_FILE}" ]] && grep -q '^TTRSS_ADMIN_PASSWORD=' "${OUTPUT_FILE}"; then
  echo "Admin password file already exists: ${OUTPUT_FILE}"
  exit 0
fi

random_password() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -base64 24 | tr -dc 'A-Za-z0-9' | head -c 16
  else
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c 16
  fi
}

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
  password="$(random_password)"
  if docker compose exec -T -e NEW_ADMIN_PASSWORD="${password}" app sh -lc \
    'sudo -Eu app php${PHP_SUFFIX:-85} ${APP_INSTALL_BASE_DIR:-/var/www/html}/tt-rss/update.php --user-set-password "admin:${NEW_ADMIN_PASSWORD}"' \
    >/dev/null 2>&1; then
    echo "Reset TTRSS admin password and saved it because startup logs were unavailable."
  else
    echo "WARNING: Could not capture or reset TTRSS admin password."
    exit 0
  fi
fi

cat >"${OUTPUT_FILE}" <<EOF
TTRSS_ADMIN_USER=admin
TTRSS_ADMIN_PASSWORD=${password}
EOF

chmod 600 "${OUTPUT_FILE}"
echo "Saved TTRSS admin password to ${OUTPUT_FILE}"
