#!/bin/bash

# Local Development Setup Script
# This script initializes all services with default configurations

set -e

echo "🚀 Setting up local development environment..."
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first:"
    echo "   sudo apt update"
    echo "   sudo apt install docker.io docker compose-v2"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose is not available. Please install it first."
    exit 1
fi

echo "✓ Docker is installed"
echo ""

# Function to setup a service
setup_service() {
    local service=$1
    echo "Setting up $service..."
    
    if [ -f "$service/.env.example" ] && [ ! -f "$service/.env" ]; then
        cp "$service/.env.example" "$service/.env"
        echo "  ✓ Created .env file from .env.example"
    elif [ -f "$service/.env" ]; then
        echo "  ℹ .env file already exists, skipping"
    fi
    
    # Create data directory if it doesn't exist
    if [ ! -d "$service/data" ]; then
        mkdir -p "$service/data"
        echo "  ✓ Created data directory"
    fi
}

# Setup each service
services=("mysql" "redis" "postgresql")

for service in "${services[@]}"; do
    if [ -d "$service" ]; then
        setup_service "$service"
    fi
done

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Review and modify .env files if needed"
echo "  2. Start services with: make up-all"
echo "  3. Check status with: make status"
echo ""
echo "For help, run: make help"
