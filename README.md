# Local Development Setup

This repository contains Docker Compose configurations for quickly setting up a local development environment on Linux Mint (or any Linux machine with Docker).

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
- **Port**: 3306
- **Location**: `./mysql`
- **Default Credentials**: See `.env` file

### Redis
In-memory data structure store for caching and sessions.
- **Port**: 6379
- **Location**: `./redis`

### PostgreSQL
Alternative relational database for projects that require it.
- **Port**: 5432
- **Location**: `./postgresql`

### Mailhog
Email testing tool that catches all outgoing emails.
- **SMTP Port**: 1025
- **Web UI Port**: 8025
- **Location**: `./mailhog`
- **Web Interface**: http://localhost:8025

## Quick Start

### Start All Services
```bash
# Start MySQL
cd mysql && docker compose up -d && cd ..

# Start Redis
cd redis && docker compose up -d && cd ..

# Start PostgreSQL
cd postgresql && docker compose up -d && cd ..

# Start Mailhog
cd mailhog && docker compose up -d && cd ..
```

### Start Individual Service
```bash
cd <service-name>
docker compose up -d
```

### Stop Services
```bash
cd <service-name>
docker compose down
```

### View Logs
```bash
cd <service-name>
docker compose logs -f
```

## Helper Scripts

Use the provided Makefile for easier management:

```bash
# Start all services
make up-all

# Stop all services
make down-all

# View status of all services
make status

# Restart all services
make restart-all
```

## Configuration

Each service has its own `.env` file for configuration. Copy the `.env.example` to `.env` and adjust as needed:

```bash
cd <service-name>
cp .env.example .env
# Edit .env with your preferred values
```

## Data Persistence

All data is persisted in `./data` directories within each service folder. These directories are git-ignored to prevent committing local data.

## Connecting to Services

### MySQL
```bash
# Command line
mysql -h 127.0.0.1 -P 3306 -u root -p

# In Laravel .env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=localdb
DB_USERNAME=root
DB_PASSWORD=password
```

### Redis
```bash
# In Laravel .env
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

### PostgreSQL
```bash
# Command line
psql -h 127.0.0.1 -p 5432 -U postgres

# In application config
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=localdb
DB_USERNAME=postgres
DB_PASSWORD=password
```

### Mailhog
```bash
# SMTP Configuration (Laravel .env)
MAIL_MAILER=smtp
MAIL_HOST=127.0.0.1
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```

## Troubleshooting

### Port Already in Use
If a port is already in use, you can change it in the `docker compose.yaml` file:
```yaml
ports:
  - "3307:3306"  # Changed from 3306 to 3307
```

### Permission Issues
If you encounter permission issues with data directories:
```bash
sudo chown -R $USER:$USER ./data
```

### Container Won't Start
Check the logs:
```bash
docker compose logs
```

## New Machine Setup

On a new laptop, simply:

1. Clone this repository
2. Install Docker and Docker Compose
3. Copy `.env.example` to `.env` in each service directory
4. Run `make up-all` or manually start each service
5. Done! All your development services are ready.

## Notes

- Data directories are git-ignored to keep the repository clean
- Always backup your data before major system changes
- Services are configured to restart automatically unless explicitly stopped
