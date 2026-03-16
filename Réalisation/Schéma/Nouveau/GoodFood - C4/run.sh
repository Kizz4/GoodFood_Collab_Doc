#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONTAINER_NAME="structurizr-goodfood-to-be"
PORT="8081"
RUNTIME_DIR="$SCHEMA_ROOT/.runtime/${CONTAINER_NAME}"
CACHE_DIR="$RUNTIME_DIR/cache"
STAGING_BASE_DIR="$RUNTIME_DIR/workspaces"
RUN_ID="$(date +%s)-$$"
STAGING_DIR="$STAGING_BASE_DIR/$RUN_ID"

mkdir -p "$CACHE_DIR"
mkdir -p "$STAGING_DIR"

# Prépare une copie propre du workspace sans fichiers parasites ni cache Structurizr.
rsync -a \
  --exclude '.structurizr' \
  --exclude 'workspace.json' \
  --exclude 'workspace.dsl.dsl' \
  --exclude 'workspace.dsl.json' \
  "$SCRIPT_DIR"/ "$STAGING_DIR"/

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

OLD_PORT_CONTAINERS="$(docker ps -q --filter "publish=${PORT}" || true)"
if [ -n "${OLD_PORT_CONTAINERS:-}" ]; then
  docker rm -f $OLD_PORT_CONTAINERS >/dev/null 2>&1 || true
fi

docker run -d --rm \
  --name "$CONTAINER_NAME" \
  -p "${PORT}:8080" \
  -e STRUCTURIZR_WORKSPACE_FILENAME=workspace \
  -v "$STAGING_DIR:/usr/local/structurizr" \
  -v "$CACHE_DIR:/usr/local/structurizr/.structurizr" \
  structurizr/lite >/dev/null

echo "Workspace source: $SCRIPT_DIR"
echo "Workspace servi: $STAGING_DIR"
echo "Cache monte: $CACHE_DIR"
echo "Structurizr Lite (TO-BE): http://localhost:${PORT}"
