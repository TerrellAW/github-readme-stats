#!/bin/bash

# Always update system packages
sudo apt update && sudo apt upgrade -y

# Enter the directory
cd ~/github-readme-stats || exit 1

# Run ssh agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Pull latest changes from remote repository
git pull origin master

# Stop and remove existing container if it exists
docker stop readme-app 2>/dev/null || true
docker rm readme-app 2>/dev/null || true

# Run docker instance
docker run -it \
    --name readme-app \
    --restart unless-stopped \
    -v $(pwd):/app \
    -p 9000:9000 \
    -w /app \
    node:lts \
	bash -c "npm i && node express.js"

# Show container status
docker ps

