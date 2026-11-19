# Public entry point: Caddy, pinned by version and digest. It puts HTTP basic
# auth in front of TeslaMate (which has no login of its own) and serves
# Grafana (own login) under /grafana.
FROM caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0

COPY Caddyfile /etc/caddy/Caddyfile
COPY --chmod=555 railway-start.sh /railway-start.sh

EXPOSE 8080
ENTRYPOINT ["/railway-start.sh"]
