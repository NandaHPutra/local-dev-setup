#!/bin/bash

# Helper script to create a new Nginx site configuration
# Usage: ./create-site.sh myproject.local /var/www/core2/myproject/public php82

set -e

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <domain> <root_path> [php_version]"
    echo ""
    echo "Examples:"
    echo "  $0 myproject.local /var/www/core2/myproject/public php82"
    echo "  $0 legacy.local /var/www/personal/legacy php74"
    echo ""
    echo "Available PHP versions: php74, php80, php82, php84"
    exit 1
fi

DOMAIN=$1
ROOT_PATH=$2
PHP_VERSION=${3:-php82}  # Default to PHP 8.2

# Validate PHP version
if [[ ! "$PHP_VERSION" =~ ^php(74|80|82|84)$ ]]; then
    echo "❌ Invalid PHP version: $PHP_VERSION"
    echo "Available versions: php74, php80, php82, php84"
    exit 1
fi

CONF_FILE="nginx/conf.d/${DOMAIN}.conf"
SAFE_DOMAIN=$(echo "$DOMAIN" | sed 's/\./_/g')

# Check if config already exists
if [ -f "$CONF_FILE" ]; then
    echo "⚠️  Configuration already exists: $CONF_FILE"
    read -p "Overwrite? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "🚀 Creating Nginx configuration for $DOMAIN..."

# Create the configuration
cat > "$CONF_FILE" << EOF
server {
    listen 80;
    server_name $DOMAIN;
    root $ROOT_PATH;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php index.html;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass ${PHP_VERSION}:9000;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_hide_header X-Powered-By;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

echo "✓ Created $CONF_FILE"
echo ""
echo "Next steps:"
echo "1. Add to /etc/hosts:"
echo "   echo '127.0.0.1 $DOMAIN' | sudo tee -a /etc/hosts"
echo ""
echo "2. Restart Nginx:"
echo "   make restart-nginx"
echo ""
echo "3. Visit http://$DOMAIN"
