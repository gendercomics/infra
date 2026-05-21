#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { echo "[$(date '+%H:%M:%S')] $*"; }

log "=== gendercomics Infrastructure Setup ==="

log "Creating external networks..."
docker network create proxy    2>/dev/null && log "  proxy: created"    || log "  proxy: already exists"
docker network create database 2>/dev/null && log "  database: created" || log "  database: already exists"
echo ""

log "Starting infrastructure (traefik + portainer)..."
docker compose -f "$SCRIPT_DIR/docker-compose.yml" up -d

echo ""
log "=== Done ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
