#!/usr/bin/env bash

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/yaronyes/profiles-rest-api.git'

PROJECT_BASE_PATH='/usr/local/apps/profiles-rest-api'

echo "Installing dependencies..."
apt-get update
apt-get install -y supervisor git docker

# Create project directory
mkdir -p $PROJECT_BASE_PATH
git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH

sudo chmod +x $PROJECT_BASE_PATH/start_application.sh

# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Run migrations and collectstatic
# cd $PROJECT_BASE_PATH
# PROJECT_BASE_PATH/env/bin/python manage.py migrate
# PROJECT_BASE_PATH/env/bin/python manage.py collectstatic --noinput

sudo docker-compose up

# build the containers using docker-compose
cd $PROJECT_BASE_PATH
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml run --rm profiles_project sh -c "python manage.py makemigrations profiles_api --noinput"
docker-compose -f docker-compose.prod.yml run --rm profiles_project sh -c "python manage.py collectstatic --no-input --clear"

# Configure supervisor
cp $PROJECT_BASE_PATH/deploy/supervisor_profiles_api.conf /etc/supervisor/conf.d/profiles_api.conf
supervisorctl reread
supervisorctl update
supervisorctl restart profiles_api

echo "DONE! :)"
