# Banian PHP docker image


Painless and production-grade docker image for hosting almost any PHP project.

## Features

- **Laravel** Support
- Production ready and stable for any PHP project
- Powered by **Nginx**, **PHP8-FPM** on latest **Ubuntu**
- PHP extensions already installed, including MongoDB driver
- Allows passing envrionment variables to PHP scripts
- Node, Yarn and Composer installed
- Auto git clone / pull

## Quick Start

Host current directory on port `8080`:

```bash
docker run -it --rm `pwd`:/var/www/src/public -p 8080:80 banian/php
```

Using **docker-compose**:

```yaml
version: '3'

services:
  myapp:
    image: banian/php
    volumes:
      - ./www:/var/www
    ports:
      - "8080:80"
    restart: always
```

## Directories

You should mount project under `/var/www/src` if you have a `public/` directory (Most of frameworks, including **Laravel**) Otherwise you can simply mount it under `/var/www/src/public`.

All logs are stored under `/var/www/logs`.

## `GIT_REPO`

Simply set this environment variable and it clones/pulls repo!

## Commands

### `fix`

This script sets correct ownership for www and log files. For faster startup, fixing `/var/www/src` will be done in background.

### `logs`

Tails all PHP and Nginx logs.

### `run-as-www`

Useful for running commands as `www-data` inside project.

**Example:** `docker exec -it [containerName] run-as-www php artisan help`

### `update`

- Run `composer install` and `yarn install` if detected. A lock file `/var/www/update.lock` will be created to prevent running more than once.

## Supervisord

If you have any daemon to run with your project just add config files into `/etc/supervisor/conf.d`

**Example:** Cronjob support

`/etc/supervisor/conf.d/cron.conf` :

```ini
[program:cron]
command = /usr/sbin/cron -f -L 15
stdout_logfile = /var/log/cron.log
stderr_logfile = /var/log/cron.log
autorestart = true
```

## License

MIT
