#!/usr/bin/env bash

# Set the script to exit immediately if any command returns a non-zero status
set -e

# Usage: start.sh <REMOTE_HOST> <SSH_PRIVATE_KEY_FILE> <SSH_PUBLIC_KEY_FILE> [SSH_KEY_PASSWORD]
#
# This script sets up SSH keys, deploys Docker services using docker-compose, and retrieves the initial admin password for Jenkins.
# It requires the following arguments:
#   - The <REMOTE_HOST> parameter should be the hostname or IP address of the remote host.
#   - The <SSH_PRIVATE_KEY_FILE> parameter should be the path to a file containing the SSH private key.
#   - The <SSH_PUBLIC_KEY_FILE> parameter should be the path to a file containing the SSH public key.
#   - The [SSH_KEY_PASSWORD] parameter is optional and can be used if the SSH private key is password-protected.
#
# Example usage:
#   ./start.sh github.com ~/.ssh/id_rsa ~/.ssh/id_rsa.pub mypassword123
#
# Please make sure to provide valid paths to your SSH key files and specify a valid remote host.
# The script assumes that you have Docker and docker-compose installed on your system.

REMOTE_HOST=$1
SSH_PRIVATE_KEY=$(cat "$2")
SSH_PUBLIC_KEY=$(cat "$3")
SSH_KEY_PASSWORD=$4

# Check if the 'ssh' directory doesn't exist, then create it
if [[ ! -d ssh ]]; then
  mkdir ssh
fi

# Save the SSH private key to 'ssh/id_rsa' file
echo "$SSH_PRIVATE_KEY" > ssh/id_rsa
# Save the SSH public key to 'ssh/id_rsa.pub' file
echo "$SSH_PUBLIC_KEY" > ssh/id_rsa.pub

# Set permissions 600 for id_rsa
chmod 600 ssh/id_rsa

# Set permissions 600 for id_rsa.pub
chmod 600 ssh/id_rsa.pub

# Create or overwrite the 'ssh/config' file with the remote host information
printf "Host %s\n\tStrictHostKeyChecking no\n" "$REMOTE_HOST" > ssh/config

# Bring down the Docker services defined in the docker-compose file and remove their volumes...
echo "Stopping services and removing volumes if they exist..."
docker compose down -v >/dev/null 2>&1

# Build the Docker services defined in the docker-compose file, passing the SSH keys as build arguments...
echo "Build the controller and node images (This may take a few minutes)..."
if [[ -n "$SSH_KEY_PASSWORD" ]]; then
  docker compose build --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" --build-arg SSH_KEY_PASSWORD="$SSH_KEY_PASSWORD" >/dev/null 2>&1
else
  docker compose build --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" >/dev/null 2>&1
fi

# Start the Docker services defined in the docker-compose file in detached mode.
echo "Start the jenkins and node in detached mode..."
docker compose up -d >/dev/null 2>&1

# Display the initial admin password for Jenkins
echo "Generating initial password..."
sleep 10
echo "Use this as administrator password:"
docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
