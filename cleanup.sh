#!/bin/bash
set -euo pipefail

# Named Docker volumes to preserve even if their container was removed.
# MongoDB and MySQL use host bind mounts — they are never affected by volume prune.
PROTECTED_VOLUMES="portainer_data"

log() { echo "[$(date '+%H:%M:%S')] $*"; }

log "=== Docker Cleanup ==="
log "Protected volumes: $PROTECTED_VOLUMES"
echo ""

log "Removing unused images..."
docker image prune -af
echo ""

log "Removing unused networks..."
docker network prune -f
echo ""

log "Removing dangling volumes (excluding protected)..."
PATTERN=$(echo "$PROTECTED_VOLUMES" | tr ' ' '|')
DANGLING=$(docker volume ls -qf dangling=true | grep -vE "^($PATTERN)$" || true)
if [ -n "$DANGLING" ]; then
    echo "$DANGLING" | xargs docker volume rm
    log "  Removed: $(echo "$DANGLING" | tr '\n' ' ')"
else
    log "  Nothing to remove."
fi

echo ""
log "=== Cleanup complete ==="
