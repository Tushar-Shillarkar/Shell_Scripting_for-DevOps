#!/bin/bash

# ADDED: Strict mode - exit immediately on error, undefined variable, or pipe failure
set -euo pipefail

<< task
deploy a django app
and handle the code for errors
task

# ADDED: Variables for clarity
REPO_DIR="django-notes-app"

code_clone() {
        echo "cloning the django app..."
        git clone https://github.com/Tushar-Shillarkar/django-notes-app.git
} 

install_requirements() {
        echo "installing dependencies.."
        # CHANGED: Added apt-get update and docker-compose-plugin
        sudo apt-get update -y
        sudo apt-get install -y docker.io nginx docker-compose-plugin
}
required_restarts() {
        # CHANGED: Added || return so function actually fails on error
        sudo chown "$USER:$USER" /var/run/docker.sock || return 1
        sudo systemctl enable docker || return 1
        sudo systemctl enable nginx || return 1
        sudo systemctl restart docker || return 1
}

deploy() {
       
        if [ -f "docker-compose.yml" ]; then
                docker compose down 2>/dev/null || true
                docker compose up -d --build
        else
                echo "docker-compose.yml not found! Falling back to plain docker..."
                docker build -t notes-app .
                # ADDED: Pass env vars so Django doesn't crash with DB_HOST=None
                docker run -d -p 8000:8000 \
                        -e DB_NAME=test_db \
                        -e DB_USER=root \
                        -e DB_PASSWORD=root \
                        -e DB_PORT=3306 \
                        -e DB_HOST=db_cont \
                        --name notes-app \
                        notes-app:latest
        fi
}


echo "*************** DEPLOYMENT STARTED ******************"

if [ -d "$REPO_DIR" ]; then
        echo "mamu repo pehlich hai"
        cd "$REPO_DIR" || exit 1
        # ADDED: Error handling on git pull
        if ! git pull; then
                echo "git pull failed"
                exit 1
        fi
else 
        if ! code_clone; then
                echo "failed to clone repo"
                exit 1
        fi
        cd "$REPO_DIR" || exit 1
fi

# ADDED: Create .env file for docker-compose (fixes the DB_HOST=None crash)
if [ ! -f ".env" ]; then
        echo "Creating .env file with DB config..."
        cat > .env << 'EOF'
DB_NAME=test_db
DB_USER=root
DB_PASSWORD=root
DB_PORT=3306
DB_HOST=db
EOF
fi

if ! install_requirements; then
        echo "installation failed"
        exit 1
fi

if ! required_restarts; then
        # CHANGED: Exit on failure instead of continuing with broken system state
        echo "system mein issue mamu"
        exit 1
fi

deploy

echo "*************** DEPLOYMENT DONE ******************"
