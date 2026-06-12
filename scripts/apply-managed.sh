#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CADDY_DIR="${CADDY_DIR:-/home/insines/stacks/caddy}"
CADDY_FILE="${CADDY_DIR}/Caddyfile"
MANAGED_DIR="${REPO_DIR}/managed"

if [ ! -d "$MANAGED_DIR" ]; then
    echo "ERROR: managed/ directory not found at $MANAGED_DIR"
    exit 1
fi

# Backup current Caddyfile
if [ -f "$CADDY_FILE" ]; then
    cp "$CADDY_FILE" "${CADDY_FILE}.bak"
fi

# Remove all managed blocks from Caddyfile
if [ -f "$CADDY_FILE" ]; then
    python3 - "$CADDY_FILE" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()
pattern = re.compile(r'# BEGIN \w+.*?# END \w+', re.S)
text = pattern.sub("", text)
text = text.strip() + "\n"
path.write_text(text)
PY
fi

# Collect all managed blocks
MANAGED_BLOCK=""
for dir in "$MANAGED_DIR"/*/; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")
    block_file="$dir/block.caddy"
    
    if [ -f "$block_file" ]; then
        echo "Adding managed block: $name"
        MANAGED_BLOCK+="# BEGIN ${name}
$(cat "$block_file")
# END ${name}

"
    fi
done

# Append managed blocks to Caddyfile
if [ -n "$MANAGED_BLOCK" ]; then
    echo "" >> "$CADDY_FILE"
    echo "$MANAGED_BLOCK" >> "$CADDY_FILE"
fi

# Validate Caddyfile
echo "Validating Caddyfile..."
docker run --rm -v "${CADDY_FILE}:/etc/caddy/Caddyfile:ro" caddy:latest caddy validate --config /etc/caddy/Caddyfile

# Restart Caddy
echo "Restarting Caddy..."
cd "$CADDY_DIR"
docker compose restart caddy

echo "Done! Managed blocks applied and Caddy restarted."
