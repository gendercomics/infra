# gendercomics infra

[![Deploy](https://github.com/gendercomics/infra/actions/workflows/deploy-docker-containers.yml/badge.svg)](https://github.com/gendercomics/infra/actions/workflows/deploy-docker-containers.yml)

Docker infrastructure for [gendercomics.net](https://gendercomics.net) — reverse proxy and container management.

## Services

| Service | Image | URL |
|---|---|---|
| Traefik | `traefik:v3.7.1` | `traefik.<HOST>` |
| Portainer | `portainer/portainer-ce:2.27.0` | `portainer.<HOST>` |

Traefik handles SSL termination via Let's Encrypt and routes traffic to all other services on the `proxy` Docker network.

## Setup

```bash
# Set the target hostname
export HOST=gendercomics.net   # or localhost for local dev

# Create networks and start services
./setup.sh
```

Two Docker networks are created:
- `proxy` — shared by all HTTP services for Traefik routing
- `database` — shared by database services

## Teardown

```bash
./cleanup.sh
```

Removes unused images, networks, and dangling volumes. The `portainer_data` volume is always preserved.

## Configuration

Traefik config is selected by the `HOST` environment variable:

| File | Used for |
|---|---|
| `traefik_gendercomics.net.toml` | Production — HTTPS with Let's Encrypt |
| `traefik_localhost.toml` | Local dev — HTTP only |

## Deployment

Pushing a git tag triggers a GitHub Actions workflow that SCPs `docker-compose.yml`, `setup.sh`, and `cleanup.sh` to the DigitalOcean server and runs `docker compose up -d`.

Required repository secrets: `DEPLOY_KEY`, `APP_HOST`, `DEPLOY_USER`.
