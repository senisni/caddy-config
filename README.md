# caddy-config

Caddy конфигурация для `coopertino`.

## Структура

```
sites/
  dashboard.caddy     # infra.insines.ru + ip-ru.insines.ru
  umami.caddy         # scitylana.insines.ru
  massage.caddy       # массаж23.рф
  obsidian.caddy      # obsidian.insines.ru
  gramps.caddy        # gramps.insines.ru
scripts/
  build.sh            # собирает Caddyfile из sites/*.caddy
  deploy.sh           # build → копирует на сервер → валидирует → перезапускает Caddy
services/caddy/
  docker-compose.yml  # compose для Caddy на сервере
```

## Как работает деплой

1. Правишь файл в `sites/`
2. Пуш в `main`
3. GitHub Actions: SSH → `git pull` → `deploy.sh`
4. `build.sh` склеивает `sites/*.caddy` в один `Caddyfile`
5. Копирует в `~/stacks/caddy/Caddyfile`
6. Валидирует через `caddy validate`
7. Перезапускает Caddy

## Добавить новый сайт

1. Создай `sites/new-site.caddy`
2. Запушь в `main`

## Ручной деплой

```bash
ssh -p 1991 insines@178.171.122.207
cd ~/caddy-config
git pull
./scripts/deploy.sh
```

## Сервер

- Caddy: `~/stacks/caddy/`
- Порты: `178.171.122.207:80/443` (публичные), `100.123.93.15:80` (Tailnet)
- `extra_hosts: host.docker.internal:host-gateway` — нужен для proxy в host-сервисы
