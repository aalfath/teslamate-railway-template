#!/bin/dash
# Runs after the migrations. On the first start, fill in TeslaMate's
# Settings -> URLs (Web App and Dashboards) from the public domain, so the
# links between TeslaMate and Grafana work at once. Values already set in
# the settings page are never overwritten.
set -e

if [ -n "${VIRTUAL_HOST:-}" ] && [ "$VIRTUAL_HOST" != "localhost" ]; then
  : "${TM_BASE_URL:=https://$VIRTUAL_HOST}"
  : "${TM_GRAFANA_URL:=https://$VIRTUAL_HOST/grafana}"
  export TM_BASE_URL TM_GRAFANA_URL
  bin/teslamate eval '
    Application.ensure_all_started(:ssl)
    Application.load(:teslamate)
    {:ok, _, _} =
      Ecto.Migrator.with_repo(TeslaMate.Repo, fn repo ->
        repo.query!(
          "UPDATE settings SET base_url = COALESCE(NULLIF(base_url, $3::text), $1::text), grafana_url = COALESCE(NULLIF(grafana_url, $3::text), $2::text)",
          [System.fetch_env!("TM_BASE_URL"), System.fetch_env!("TM_GRAFANA_URL"), ""],
          log: false
        )
      end)
  ' || echo "[railway] could not preset the URLs in Settings; set them in the settings page" >&2
fi

exec "$@"
