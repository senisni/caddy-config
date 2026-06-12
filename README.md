# Caddy Config Repository

Centralized management for all Caddy configurations on `coopertino`.

## Structure

```
managed/
├── insines-dashboard/
│   └── block.caddy      # http://infra.insines.ru + ip-ru.insines.ru
├── umami/
│   └── block.caddy      # scitylana.insines.ru
├── obsidian/
│   └── block.caddy      # obsidian.insines.ru
├── gramps/
│   └── block.caddy      # gramps.insines.ru
└── massage/
    └── block.caddy      # массаж23.рф
services/
└── caddy/
    └── docker-compose.yml
scripts/
└── apply-managed.sh
```

## Adding a New Service

1. Create a new directory in `managed/` with the service name
2. Add a `block.caddy` file with the Caddy configuration
3. Push to main - GitHub Actions will deploy automatically

## Manual Deployment

```bash
ssh -p 1991 insines@178.171.122.207
cd ~/caddy-config
./scripts/apply-managed.sh
```

## How It Works

The `apply-managed.sh` script:
1. Backs up the current Caddyfile
2. Removes all existing managed blocks (marked with `# BEGIN ...` / `# END ...`)
3. Collects all `managed/*/block.caddy` files
4. Appends them to the Caddyfile with markers
5. Validates the configuration with `caddy validate`
6. Restarts Caddy

## Managed Block Format

Each managed block must be wrapped in markers:

```caddy
# BEGIN service-name
... configuration ...
# END service-name
```
