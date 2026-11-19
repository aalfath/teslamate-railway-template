#!/bin/sh
# Railway defaults for TeslaMate's Grafana. Every value can be overridden
# with a service variable of the same name.
set -e

export GF_SERVER_HTTP_PORT="${PORT:-3000}"

if [ -z "${GF_SECURITY_ADMIN_PASSWORD:-}" ] || [ "$GF_SECURITY_ADMIN_PASSWORD" = "admin" ]; then
  echo "[railway] GF_SECURITY_ADMIN_PASSWORD must be set to a strong password: refusing to start." >&2
  exit 1
fi

exec /run.sh "$@"
