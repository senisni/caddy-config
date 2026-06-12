#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SITES_DIR="${REPO_DIR}/sites"
OUTPUT="${REPO_DIR}/Caddyfile"

> "$OUTPUT"

for f in "$SITES_DIR"/internal/*.caddy "$SITES_DIR"/external/*.caddy; do
    [ -f "$f" ] || continue
    cat "$f" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
done

echo "Built Caddyfile from $(find "$SITES_DIR" -name '*.caddy' | wc -l | tr -d ' ') sites"
