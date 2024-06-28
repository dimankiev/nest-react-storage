#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check for required commands
for cmd in git docker docker-compose; do
  if ! command_exists "$cmd"; then
    echo "Error: $cmd is not installed. Please install it and try again."
    exit 1
  fi
done

# Check for required files
for file in docker-compose.yml .env; do
  if [ ! -f "$file" ]; then
    echo "Error: $file not found in the current directory."
    exit 1
  fi
done

# Clone frontend repository
if [ ! -d "frontend" ]; then
  git clone https://github.com/dimankiev/nest-react-storage-ui frontend
else
  echo "Frontend directory already exists. Skipping clone."
fi

# Clone backend repository
if [ ! -d "backend" ]; then
  git clone https://github.com/dimankiev/nest-react-storage-api backend
else
  echo "Backend directory already exists. Skipping clone."
fi

# Navigate to frontend directory and pull latest changes
cd frontend
git pull
cd ..

# Navigate to backend directory and pull latest changes
cd backend
git pull
cd ..

# Build and start Docker containers
docker-compose up --build -d

echo "Deployment completed successfully!"