# TeslaMate's Grafana image (Grafana 13.3.1 with the TeslaMate dashboards and
# datasource), pinned by version and digest.
FROM teslamate/grafana:4.5.0@sha256:598c65f4fbefaccc213d16fde5b86b5e71366bd391c00b28ff64b976e0841dde

# Served under /grafana on the public gateway domain (GF_SERVER_ROOT_URL).
ENV GF_SERVER_SERVE_FROM_SUB_PATH=true

# Railway volumes are mounted as root, so Grafana runs as root to write
# /var/lib/grafana.
USER root
COPY --chmod=555 railway-start.sh /railway-start.sh

EXPOSE 3000
ENTRYPOINT ["/railway-start.sh"]
