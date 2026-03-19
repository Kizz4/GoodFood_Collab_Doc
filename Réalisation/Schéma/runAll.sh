#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OPEN_BROWSER=true
START_STRUCTURIZR=true

LABELS=(
  "TO-BE"
  "Option 3"
)

RUN_SCRIPTS=(
  "$SCRIPT_DIR/Nouveau/GoodFood - C4/run.sh"
  "$SCRIPT_DIR/Nouveau/GoodFood - C4-Option3/run.sh"
)

STRUCTURIZR_URLS=(
  "http://localhost:8081"
  "http://localhost:8083"
)

usage() {
  cat <<'EOF'
Usage: ./runAll.sh [options]

Options:
  --no-browser        N'ouvre pas les URLs Structurizr dans le navigateur
  --no-drawio         N'ouvre pas les fichiers .drawio
  --drawio-only       Ouvre seulement les fichiers .drawio
  --structurizr-only  Demarre seulement les workspaces Structurizr
  --help              Affiche cette aide

Variables utiles:
  DRAWIO_APP="draw.io"  Force une application pour ouvrir les fichiers .drawio sur macOS
EOF
}

open_target() {
  local target="$1"

  if command -v open >/dev/null 2>&1; then
      open "$target" >/dev/null 2>&1
    return 0
  fi

  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$target" >/dev/null 2>&1
    return 0
  fi

  return 1
}

start_structurizr() {
  local failed=0

  if ! command -v docker >/dev/null 2>&1; then
    echo "Docker est introuvable dans le PATH."
    return 1
  fi

  for i in "${!RUN_SCRIPTS[@]}"; do
    local label="${LABELS[$i]}"
    local script="${RUN_SCRIPTS[$i]}"

    if [ ! -f "$script" ]; then
      echo "Script manquant pour ${label}: $script"
      failed=1
      continue
    fi

    echo "Demarrage ${label}..."
    if ! bash "$script"; then
      echo "Echec au demarrage de ${label}."
      failed=1
    fi
  done

  if [ "$OPEN_BROWSER" = true ] && [ "$failed" -eq 0 ]; then
    sleep 2
    for url in "${STRUCTURIZR_URLS[@]}"; do
      if ! open_target "$url"; then
        echo "Impossible d'ouvrir automatiquement ${url}."
      fi
    done
  fi

  return "$failed"
}


for arg in "$@"; do
  case "$arg" in
    --no-browser)
      OPEN_BROWSER=false
      ;;
    --structurizr-only)
      START_STRUCTURIZR=true
      OPEN_DRAWIO=false
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Option inconnue: $arg"
      usage
      exit 1
      ;;
  esac
done

STRUCTURIZR_STATUS=0

if [ "$START_STRUCTURIZR" = true ]; then
  if ! start_structurizr; then
    STRUCTURIZR_STATUS=1
  fi
fi

echo
echo "Ressources Structurizr:"
for i in "${!STRUCTURIZR_URLS[@]}"; do
  echo "  - ${LABELS[$i]}: ${STRUCTURIZR_URLS[$i]}"
done

if [ "$STRUCTURIZR_STATUS" -ne 0 ]; then
  exit "$STRUCTURIZR_STATUS"
fi
