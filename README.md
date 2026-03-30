# Local Development Setup #

This repository provides a Docker-based local development environment for PHP and web projects. It includes databases, Mailhog, Nginx, multiple PHP-FPM versions, and an optional `code-server` container for browser-based editing.

It is designed for Linux Mint or any Linux machine with Docker and Docker Compose V2.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+

## Installation

```bash
# Install Docker (if not already installed)
sudo apt update
sudo apt install docker.io docker compose
sudo usermod -aG docker $USER
# Log out and log back in for group changes to take effect
```

## Available Services

### MySQL
Database server for Laravel and other PHP applications.
- Port: `3306`
- Location: `./mysql`
- Data path: `./mysql/data`

### Redis
In-memory data store for caching, queues, and sessions.
- Port: `6379`
- Location: `./redis`
- Data path: `./redis/data`

### PostgreSQL
Alternative relational database for projects that require PostgreSQL.
- Port: `5432`
- Location: `./postgresql`
- Data path: `./postgresql/data`

### Mailhog
Email testing tool that catches outgoing mail.
- SMTP port: `1025`
- Web UI port: `8025`
- Location: `./mailhog`
- Web interface: http://localhost:8025

### PHP-FPM
Multiple PHP runtimes are available so legacy and modern projects can run side by side.

| Version | Service | Host Port | Directory |
| --- | --- | --- | --- |
| PHP 7.4 | `php74` | `9074` | `./php-7.4` |
| PHP 8.0 | `php80` | `9080` | `./php-8.0` |
| PHP 8.2 | `php82` | `9082` | `./php-8.2` |
| PHP 8.4 | `php84` | `9084` | `./php-8.4` |

Each PHP container mounts your projects directory into `/var/www` and includes common extensions plus Composer.

### Nginx
Reverse proxy and local web server for your projects.
- HTTP port: `80`
- HTTPS port: `443`
- Location: `./nginx`

Nginx routes local domains to project directories and forwards PHP requests to the selected PHP-FPM container.

### code-server
Optional browser-based VS Code environment.
- Web UI port: `8443`
- Location: `./code-server`
- Web interface: http://localhost:8443

## Architecture

- A shared Docker network named `dev-network` connects Nginx, `code-server`, and the PHP containers.
- PHP and Nginx mount a host directory defined by `PROJECTS_PATH` so your local projects are available inside containers at `/var/www`.
- Nginx site config files in `nginx/conf.d/` choose which local domain and root path map to which PHP version.

## Quick Start

### 1. Initial setup

```bash
./setup.sh
```

This creates missing `.env` files for the core database services and creates local data directories.

### 2. Configure your projects path

Set `PROJECTS_PATH` in these files to the directory that contains your projects:

- `nginx/.env`
- `php-7.4/.env`
- `php-8.0/.env`
- `php-8.2/.env`
- `php-8.4/.env`
- `code-server/.env` if you want browser-based editing

Example:

```env
PROJECTS_PATH=/home/your-user/projects
```

If an `.env` file does not exist yet, copy it from `.env.example` first.

### 3. Start the stack

```bash
# Start everything except code-server
make up-all

# Optional: start code-server
make up-code-server
```

`make up-all` starts:

- MySQL
- Redis
- PostgreSQL
- Mailhog
- PHP 7.4
- PHP 8.0
- PHP 8.2
- PHP 8.4
- Nginx

### 4. Check container status

```bash
make status
```

## Common Commands

```bash
# Start all services
make up-all

# Start only the web stack
make up-web

# Stop all services
make down-all

# Restart all services
make restart-all

# Start specific services
make up-mysql
make up-redis
make up-postgres
make up-mailhog
make up-php82
make up-nginx
make up-code-server
```

## Creating a Local Site

You can either create an Nginx config manually from the examples in `nginx/conf.d/` or use the helper script.

### Using the helper script

```bash
./create-site.sh myproject.local /var/www/myproject/public php82
```

Arguments:

- Local domain name
- Project root path as seen inside the container
- PHP version: `php74`, `php80`, `php82`, or `php84`

Example for a Laravel project stored at `${PROJECTS_PATH}/myproject`:

```bash
./create-site.sh myproject.local /var/www/myproject/public php82
```

After creating the config:

1. Add the domain to `/etc/hosts`
2. Restart Nginx with `make restart-nginx`
3. Visit `http://myproject.local`

### Manual Nginx config

Useful templates are available in:

- `nginx/conf.d/example-laravel.conf.example`
- `nginx/conf.d/example-basic-php.conf.example`
- `nginx/conf.d/example-multi-version.conf.example`

See `nginx/conf.d/README.md` for more details.

## Connecting to Services

### MySQL

```bash
# Command line
mysql -h 127.0.0.1 -P 3306 -u root -p

# Laravel .env example
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=localdb
DB_USERNAME=root
DB_PASSWORD=password
```

### Redis

```bash
# Laravel .env example
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

### PostgreSQL

```bash
# Command line
psql -h 127.0.0.1 -p 5432 -U postgres

# Application config example
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=localdb
DB_USERNAME=postgres
DB_PASSWORD=password
```

### Mailhog

```bash
# Laravel .env example
MAIL_MAILER=smtp
MAIL_HOST=127.0.0.1
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```

### PHP-FPM backends inside Docker

Nginx communicates with PHP-FPM using these internal service names:

- `php74:9000`
- `php80:9000`
- `php82:9000`
- `php84:9000`

## Configuration

Most services include a `.env.example` file. Copy it to `.env` and adjust values as needed:

```bash
cp <service>/.env.example <service>/.env
```

Common configuration files:

- `mysql/.env`
- `redis/.env` if needed in the future
- `postgresql/.env`
- `nginx/.env`
- `php-7.4/.env`
- `php-8.0/.env`
- `php-8.2/.env`
- `php-8.4/.env`
- `code-server/.env`

## Data Persistence

Persistent service data is stored in local `data/` directories and is git-ignored.

Examples:

- `mysql/data`
- `redis/data`
- `postgresql/data`
- `code-server/data`

## Logs

```bash
make logs-mysql
make logs-redis
make logs-postgres
make logs-mailhog
make logs-code-server
make logs-php74
make logs-php80
make logs-php82
make logs-php84
make logs-nginx
```

## Troubleshooting

### Port already in use

If a port is already in use, change it in the relevant `docker-compose.yaml` file.

```yaml
ports:
  - "3307:3306"
```

### Permission issues

If you encounter permission issues with data directories:

```bash
sudo chown -R $USER:$USER ./data
```

### Container will not start

Check logs for the affected service:

```bash
docker compose logs
```

For Docker Compose compatibility issues, see `TROUBLESHOOTING.md`.

## New Machine Setup

1. Clone this repository
2. Install Docker and Docker Compose V2
3. Run `./setup.sh`
4. Copy missing `.env.example` files to `.env` where needed
5. Set `PROJECTS_PATH` for Nginx and the PHP services
6. Start the stack with `make up-all`
7. Optionally start `code-server` with `make up-code-server`
8. Create local site configs for your projects

## Notes

- Data directories are git-ignored to keep the repository clean
- Services are configured to restart automatically unless explicitly stopped
- The default catch-all Nginx config uses PHP 8.2 for quick testing
- Back up your local databases before deleting `data/` directories
