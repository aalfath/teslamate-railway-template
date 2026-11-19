#!/bin/dash
# Railway defaults for TeslaMate. Every value can be overridden with a
# service variable of the same name.
set -e

: "${PORT:=4000}"
export PORT

# Railway's private network resolves *.railway.internal over IPv6.
case "${DATABASE_HOST:-}" in
  *.railway.internal) : "${DATABASE_IPV6:=true}"; export DATABASE_IPV6 ;;
esac

# MQTT is optional: without a broker, TeslaMate would refuse to start.
if [ -z "${MQTT_HOST:-}" ]; then
  : "${DISABLE_MQTT:=true}"
  export DISABLE_MQTT
fi
case "${MQTT_HOST:-}" in
  *.railway.internal) : "${MQTT_IPV6:=true}"; export MQTT_IPV6 ;;
esac

# Only accept browser websockets from the public domain (VIRTUAL_HOST).
: "${CHECK_ORIGIN:=true}"
export CHECK_ORIGIN

if [ -z "${ENCRYPTION_KEY:-}" ]; then
  echo "[railway] ENCRYPTION_KEY is not set: refusing to start." >&2
  exit 1
fi

# Stable session key across restarts, derived from ENCRYPTION_KEY.
if [ -z "${SECRET_KEY_BASE:-}" ]; then
  SECRET_KEY_BASE=$(printf 'teslamate-secret-key-base:%s' "$ENCRYPTION_KEY" | sha512sum | cut -c1-128)
  export SECRET_KEY_BASE
fi

exec /bin/dash /entrypoint.sh /bin/dash /railway/railway-urls.sh "$@"
