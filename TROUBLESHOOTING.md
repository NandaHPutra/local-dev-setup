# Docker Compose Troubleshooting

## Error: ModuleNotFoundError: No module named 'distutils'

This error occurs when using docker-compose 1.29.2 with Python 3.12+, as `distutils` was removed from the Python standard library.

### Solution 1: Install distutils (Quick Fix)

```bash
sudo apt update
sudo apt install python3-distutils
```

### Solution 2: Upgrade to Docker Compose V2 (Recommended)

Docker Compose V2 is written in Go and doesn't have Python dependencies:

```bash
# Remove old docker-compose
sudo apt remove docker-compose

# Install Docker Compose V2
sudo apt update
sudo apt install docker-compose-plugin

# Verify installation
docker compose version

# If installed successfully, update Makefile to use 'docker compose'
sed -i 's/docker-compose/docker compose/g' Makefile
sed -i 's/docker-compose/docker compose/g' README.md QUICK_REFERENCE.md nginx/conf.d/README.md setup.sh
```

### Solution 3: Install Docker Compose V2 Manually

```bash
# Download the latest version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make it executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

### After Fixing

Once you've applied one of the solutions above, try:

```bash
make up-mysql
```

## Current Status

Your system has docker-compose 1.29.2 which is incompatible with Python 3.12+. Choose one of the solutions above.
