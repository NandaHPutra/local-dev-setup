# Nginx Site Configuration README

## Quick Start

1. Copy an example configuration file and rename it:
   ```bash
   cp example-laravel.conf.example myproject.conf
   ```

2. Edit the configuration:
   - Change `server_name` to your local domain (e.g., myproject.local)
   - Update `root` to point to your project directory
   - Choose the correct PHP version in `fastcgi_pass`

3. Add the domain to your `/etc/hosts`:
   ```bash
   sudo nano /etc/hosts
   # Add this line:
   127.0.0.1 myproject.local
   ```

4. Restart Nginx:
   ```bash
   cd nginx
   docker compose restart
   ```

5. Visit http://myproject.local in your browser

## Available PHP-FPM Backends

- `php74:9000` - PHP 7.4
- `php80:9000` - PHP 8.0
- `php82:9000` - PHP 8.2
- `php84:9000` - PHP 8.4

Just change the `fastcgi_pass` directive to use a different PHP version.

## Configuration Templates

### Laravel/Lumen Framework
Use `example-laravel.conf.example` as a starting point. This includes proper routing for framework projects.

### Basic PHP Projects
Use `example-basic-php.conf.example` for simple PHP projects without a routing system.

### Multiple PHP Versions
See `example-multi-version.conf.example` for running different projects with different PHP versions.

## Testing PHP Versions

Create a `phpinfo.php` file in your project root:
```php
<?php
phpinfo();
```

Access it via your configured domain to verify which PHP version is being used.

## Common Issues

### 502 Bad Gateway
- Make sure the PHP-FPM container is running: `docker ps | grep php`
- Check that the `fastcgi_pass` hostname matches the container name
- Verify the network connection between containers

### File Not Found
- Ensure the `root` path in your config matches your project structure
- Check that the PHP file exists and has correct permissions
- Look at Nginx logs: `docker compose logs nginx`

### Changes Not Applied
- Always restart Nginx after config changes: `docker compose restart`
- Check for syntax errors: `docker compose exec nginx nginx -t`
