.PHONY: help up-all down-all restart-all status network

# Default target
help:
	@echo "Local Development Setup - Available Commands:"
	@echo ""
	@echo "  make up-all         - Start all services"
	@echo "  make up-web         - Start web stack (PHP + Nginx)"
	@echo "  make down-all       - Stop all services"
	@echo "  make restart-all    - Restart all services"
	@echo "  make status         - Show status of all services"
	@echo ""
	@echo "Database services:"
	@echo "  make up-mysql       - Start MySQL"
	@echo "  make up-redis       - Start Redis"
	@echo "  make up-postgres    - Start PostgreSQL"
	@echo ""
	@echo "Web services:"
	@echo "  make up-php74       - Start PHP 7.4"
	@echo "  make up-php80       - Start PHP 8.0"
	@echo "  make up-php82       - Start PHP 8.2"
	@echo "  make up-php84       - Start PHP 8.4"
	@echo "  make up-nginx       - Start Nginx"
	@echo ""
	@echo "Other services:"
	@echo "  make up-mailhog     - Start Mailhog"

# Create shared network
network:
	@docker network inspect dev-network >/dev/null 2>&1 || docker network create dev-network

# Start all services
up-all: network up-mysql up-redis up-postgres up-mailhog up-php74 up-php80 up-php82 up-php84 up-nginx
	@echo "✓ All services started"

# Start web stack only (PHP + Nginx)
up-web: network up-php74 up-php80 up-php82 up-php84 up-nginx
	@echo "✓ Web stack started"

# Stop all services
down-all: down-nginx down-php74 down-php80 down-php82 down-php84 down-mysql down-redis down-postgres down-mailhog
	@echo "✓ All services stopped"

# Restart all services
restart-all: down-all up-all
	@echo "✓ All services restarted"

# Show status of all services
status:
	@echo "Service Status:"
	@docker ps -a --filter "name=mysql" --filter "name=redis" --filter "name=postgres" --filter "name=mailhog" --filter "name=php" --filter "name=nginx" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Individual service commands
up-mysql:
	@cd mysql && docker compose up -d
	@echo "✓ MySQL started on port 3306"

up-redis:
	@cd redis && docker compose up -d
	@echo "✓ Redis started on port 6379"

up-postgres:
	@cd postgresql && docker compose up -d
	@echo "✓ PostgreSQL started on port 5432"

up-mailhog:
	@cd mailhog && docker compose up -d
	@echo "✓ Mailhog started - SMTP: 1025, Web UI: http://localhost:8025"

down-mysql:
	@cd mysql && docker compose down

down-redis:
	@cd redis && docker compose down

down-postgres:
	@cd postgresql && docker compose down

down-mailhog:
	@cd mailhog && docker compose down

# PHP services
up-php74:
	@cd php-7.4 && docker compose up -d
	@echo "✓ PHP 7.4 started on port 9074"

up-php80:
	@cd php-8.0 && docker compose up -d
	@echo "✓ PHP 8.0 started on port 9080"

up-php82:
	@cd php-8.2 && docker compose up -d
	@echo "✓ PHP 8.2 started on port 9082"

up-php84:
	@cd php-8.4 && docker compose up -d
	@echo "✓ PHP 8.4 started on port 9084"

down-php74:
	@cd php-7.4 && docker compose down

down-php80:
	@cd php-8.0 && docker compose down

down-php82:
	@cd php-8.2 && docker compose down

down-php84:
	@cd php-8.4 && docker compose down

# Nginx
up-nginx:
	@cd nginx && docker compose up -d
	@echo "✓ Nginx started on port 80"

down-nginx:
	@cd nginx && docker compose down

restart-nginx:
	@cd nginx && docker compose restart
	@echo "✓ Nginx restarted"

# Logs
logs-mysql:
	@cd mysql && docker compose logs -f

logs-redis:
	@cd redis && docker compose logs -f

logs-postgres:
	@cd postgresql && docker compose logs -f

logs-mailhog:
	@cd mailhog && docker compose logs -f

logs-php74:
	@cd php-7.4 && docker compose logs -f

logs-php80:
	@cd php-8.0 && docker compose logs -f

logs-php82:
	@cd php-8.2 && docker compose logs -f

logs-php84:
	@cd php-8.4 && docker compose logs -f

logs-nginx:
	@cd nginx && docker compose logs -f
