#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_NAME="structurizr-goodfood-to-be"
PORT="8081"
CACHE_DIR="/tmp/${CONTAINER_NAME}-cache"
STAGING_DIR="/tmp/${CONTAINER_NAME}-workspace"

mkdir -p "$CACHE_DIR"
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

# Monte une copie propre du workspace pour forcer le chargement du DSL source.
cp -R "$SCRIPT_DIR"/. "$STAGING_DIR"
rm -f "$STAGING_DIR/workspace.json" "$STAGING_DIR/workspace.dsl.dsl" "$STAGING_DIR/workspace.dsl.json"

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
