#!/bin/sh
# Defaults for the gateway. Every value can be overridden with a service
# variable of the same name.
set -e

: "${PORT:=8080}"
: "${WEB_USERNAME:=admin}"
: "${TESLAMATE_UPSTREAM:=teslamate:4000}"
: "${GRAFANA_UPSTREAM:=grafana:3000}"

if [ -z "${WEB_PASSWORD:-}" ] || [ "${#WEB_PASSWORD}" -lt 12 ]; then
  echo "[railway] WEB_PASSWORD must be set (12 characters or more): refusing to start." >&2
  exit 1
fi

WEB_PASSWORD_HASH=$(caddy hash-password --plaintext "$WEB_PASSWORD")
export PORT WEB_USERNAME WEB_PASSWORD_HASH TESLAMATE_UPSTREAM GRAFANA_UPSTREAM
unset WEB_PASSWORD

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
