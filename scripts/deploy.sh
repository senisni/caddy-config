#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CADDY_DIR="${CADDY_DIR:-/home/insines/stacks/caddy}"

"${REPO_DIR}/scripts/build.sh"

cp "${REPO_DIR}/Caddyfile" "${CADDY_DIR}/Caddyfile"

docker run --rm -v "${CADDY_DIR}/Caddyfile:/etc/caddy/Caddyfile:ro" caddy:latest caddy validate --config /etc/caddy/Caddyfile

cd "$CADDY_DIR"
docker compose restart caddy

echo "Done."
