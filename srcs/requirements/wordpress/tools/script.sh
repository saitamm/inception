#!/bin/bash
set -e

# Build the WordPress PHP-FPM container
echo "Building WordPress container..."
docker build -t wordpress wordpress

# Create volume for WordPress files if it doesn't exist
docker volume inspect wp_files >/dev/null 2>&1 || docker volume create wp_files

# Run WordPress container connected to wp-network
echo "Starting WordPress container..."
docker run -d \
  --name wordpress \
  --network wp-network \
  -v wp_files:/var/www/html \
  my-wordpress

echo "WordPress container is running and connected to wp-network."
