# TeslaMate, official image pinned by version and digest.
FROM teslamate/teslamate:4.5.0@sha256:a285b02171a789cf2af5075502d2ec9034b58a42db777a30ae86aef2d0c12af4

COPY --chmod=555 railway-start.sh railway-urls.sh /railway/

EXPOSE 4000

# railway-start.sh sets Railway defaults, then hands over to the upstream
# entrypoint (waits for Postgres and runs the migrations), then presets the
# app URLs once and starts TeslaMate.
ENTRYPOINT ["tini", "--", "/bin/dash", "/railway/railway-start.sh"]
CMD ["bin/teslamate", "start"]
