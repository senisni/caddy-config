# caddy-config

Caddy конфигурация для `coopertino`.

## Структура

```
Caddyfile                  # единственный конфиг со всеми хостами
scripts/deploy.sh          # копирует Caddyfile на сервер и перезапускает Caddy
.github/workflows/deploy.yml  # CI: push → deploy
services/caddy/docker-compose.yml  # compose для Caddy на сервере
```

## Хосты

| Хост | Сервис | Описание |
|------|--------|----------|
| `scitylana.insines.ru` | Umami | Аналитика |
| `массаж23.рф` | massage-anapa:3001 | Массажный сайт |
| `obsidian.insines.ru` | couchdb:5984 | Obsidian sync (IP allowlist) |
| `gramps.insines.ru` | gramps-web:5000 | Genealogy (IP allowlist) |
| `http://infra.insines.ru` | dashboard + API | Инфраструктурный дашборд |
| `ip-ru.insines.ru` | ip-echo:3002 | Публичный IP endpoint |

## Как работает деплой

1. Правишь `Caddyfile` в этом репозитории
2. Пуш в `main`
3. GitHub Actions подключается к серверу по SSH (порт 1991)
4. `deploy.sh` копирует Caddyfile в `~/stacks/caddy/`
5. Валидирует через `caddy validate`
6. Перезапускает Caddy

## Добавить новый хост

1. Добавь блок в `Caddyfile`
2. Запушь в `main`
3. Всё, хост работает

## Ручной деплой

```bash
ssh -p 1991 insines@178.171.122.207
cd ~/caddy-config
git pull
./scripts/deploy.sh
```

## Сервер

- Caddy живёт в Docker: `~/stacks/caddy/`
- Compose: `services/caddy/docker-compose.yml`
- Порты: `178.171.122.207:80/443` (публичные), `100.123.93.15:80` (Tailnet)
- `extra_hosts: host.docker.internal:host-gateway` — нужен для proxy в host-сервисы
