# TeslaMate on Railway

A Railway template for [TeslaMate](https://github.com/teslamate-org/teslamate), the self-hosted data logger for Tesla cars, with its Grafana dashboards.

This repository is the source of the template. Every app service builds from it, so when a new TeslaMate version is merged here, Railway shows an "update available" notice to everyone who deployed the template, and they choose when to apply it.

## What it deploys

| Service | Built from | What it does |
| --- | --- | --- |
| `gateway` | [`gateway/`](gateway/) (Caddy 2.11.9, pinned by digest) | The only public service. Puts a login (HTTP basic auth) in front of TeslaMate, which has none of its own, and serves Grafana under `/grafana`. Health check at `/healthz`. |
| `teslamate` | [`teslamate/`](teslamate/) (`teslamate/teslamate:4.5.0`, pinned by digest) | Logs your cars' drives, charges and states to Postgres. Private only. |
| `grafana` | [`grafana/`](grafana/) (`teslamate/grafana:4.5.0`, Grafana 13.3.1, pinned by digest) | TeslaMate's dashboards. Private only, reached through the gateway. Data on a volume at `/var/lib/grafana`. |
| `Postgres` | Railway's Postgres | TeslaMate's database, on a volume. |

## Variables

All of them are filled in for you; nothing to type at deploy time.

| Service | Variable | Default | Notes |
| --- | --- | --- | --- |
| gateway | `WEB_USERNAME` | `admin` | User name for the TeslaMate login. |
| gateway | `WEB_PASSWORD` | generated | Password for the TeslaMate login. Read it in the gateway's Variables tab. |
| teslamate | `ENCRYPTION_KEY` | generated | Encrypts your Tesla API tokens in the database. Don't change it after the first sign-in. |
| teslamate | `VIRTUAL_HOST` | gateway's public domain | Used for links and the websocket origin check. |
| teslamate | `DATABASE_*` | references to Postgres | |
| grafana | `GF_SECURITY_ADMIN_PASSWORD` | generated | Grafana's `admin` password on first start. Change it in Grafana afterwards. |
| grafana | `GF_SERVER_ROOT_URL` | `https://<gateway domain>/grafana` | |
| grafana | `DATABASE_*` | references to Postgres | Grafana's TeslaMate datasource. |

Optional, set on the `teslamate` service if you want them: `TZ` (for example `Europe/Berlin`), and `MQTT_HOST`, `MQTT_PORT`, `MQTT_USERNAME`, `MQTT_PASSWORD` to publish to your own MQTT broker (Home Assistant). MQTT is off while `MQTT_HOST` is empty. See TeslaMate's [environment variables](https://docs.teslamate.org/docs/configuration/environment_variables).

## First steps after deploying

1. Open the gateway's public URL and log in with `admin` and the gateway's `WEB_PASSWORD`.
2. Sign in to Tesla with an access and refresh token ([how to get them](https://docs.teslamate.org/docs/installation/tokens)).
3. Open the dashboards at `https://YOUR-DOMAIN/grafana` and log in with `admin` and the grafana service's `GF_SECURITY_ADMIN_PASSWORD`.

The Web App and Dashboards URLs in TeslaMate's Settings are filled in from the public domain on first start. If you add a custom domain, update them there and change `VIRTUAL_HOST` and `GF_SERVER_ROOT_URL`.

## Updates

Pinned versions are bumped here with a `CHANGELOG.md` entry. TeslaMate runs its database migrations on start. Read the [CHANGELOG](CHANGELOG.md) and TeslaMate's [upgrade notes](https://docs.teslamate.org/docs/upgrading) before applying an update.

## License

TeslaMate is licensed under AGPL-3.0 by its authors. This repository only holds the Railway wrapper.
