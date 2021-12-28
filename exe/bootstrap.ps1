#!/usr/bin/env pwsh

echo "Copying .env.example to .env..."
Copy-Item -Path "$(pwd)\branchprotection\.env.example" -Destination "$(pwd)\branchprotection\.env"

echo "Building docker image..."
docker build -t branchprotection .
