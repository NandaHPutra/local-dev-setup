# Quick Reference Guide

## Starting Fresh on a New Machine

```bash
# 1. Clone this repository
git clone <your-repo-url> ~/local-dev-setup
cd ~/local-dev-setup

# 2. Install Docker (if not installed)
sudo apt update
sudo apt install docker.io docker compose
sudo usermod -aG docker $USER
# Log out and back in

# 3. Run setup script
./setup.sh

# 4. Start all services
make up-all
```

## Daily Usage

```bash
# Start all services
make up-all

# Stop all services
make down-all

# Check what's running
make status

# View logs for a specific service
cd mysql && docker compose logs -f
```

## Connection Strings

### Laravel .env Example
```env
# MySQL
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=localdb
DB_USERNAME=root
DB_PASSWORD=password

# Redis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

# Mail (Mailhog)
MAIL_MAILER=smtp
MAIL_HOST=127.0.0.1
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```

### PostgreSQL Connection
```bash
# Command line
psql -h 127.0.0.1 -p 5432 -U postgres

# Connection string
postgresql://postgres:password@127.0.0.1:5432/localdb
```

### Node.js Example
```javascript
// MySQL
const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: '127.0.0.1',
  port: 3306,
  user: 'root',
  password: 'password',
  database: 'localdb'
});

// Redis
const redis = require('redis');
const client = redis.createClient({
  host: '127.0.0.1',
  port: 6379
});

// PostgreSQL
const { Pool } = require('pg');
const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  user: 'postgres',
  password: 'password',
  database: 'localdb'
});
```

## Troubleshooting

### Service won't start
```bash
# Check if port is already in use
sudo netstat -tulpn | grep <port>

# View service logs
cd <service> && docker compose logs
```

### Clear all data and start fresh
```bash
# Stop all services
make down-all

# Remove data directories (WARNING: This deletes all data)
rm -rf mysql/data redis/data postgresql/data

# Start services again (will create fresh databases)
make up-all
```

### Reset a specific service
```bash
cd <service>
docker compose down -v  # -v removes volumes
rm -rf data/
docker compose up -d
```

## Adding More Services

To add a new service (e.g., MongoDB):

1. Create directory: `mkdir mongodb`
2. Create `docker compose.yaml` with service configuration
3. Create `.env.example` with default values
4. Create `.gitignore` with `data/` and `.env`
5. Update `Makefile` with new targets
6. Update `README.md` with service info

## Backup and Restore

### Backup MySQL Database
```bash
docker exec mysql mysqldump -u root -ppassword localdb > backup.sql
```

### Restore MySQL Database
```bash
docker exec -i mysql mysql -u root -ppassword localdb < backup.sql
```

### Backup PostgreSQL Database
```bash
docker exec postgres pg_dump -U postgres localdb > backup.sql
```

### Restore PostgreSQL Database
```bash
docker exec -i postgres psql -U postgres localdb < backup.sql
```
