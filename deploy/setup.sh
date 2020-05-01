#!/usr/bin/env bash

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/yaronyes/profiles-rest-api.git'

PROJECT_BASE_PATH='/usr/local/apps/profiles-rest-api'

echo "Installing dependencies..."
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce


sudo apt-get install -y supervisor git

# Create project directory
mkdir -p $PROJECT_BASE_PATH
git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH

sudo chmod +x $PROJECT_BASE_PATH/start_application.sh

# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Run migrations and collectstatic
# cd $PROJECT_BASE_PATH
# PROJECT_BASE_PATH/env/bin/python manage.py migrate
# PROJECT_BASE_PATH/env/bin/python manage.py collectstatic --noinput



# build the containers using docker-compose
cd $PROJECT_BASE_PATH
sudo docker-compose -f docker-compose.prod.yml build
sudu docker-compose -f docker-compose.prod.yml run --rm profiles_project sh -c "python manage.py migrate --noinput"
sudo docker-compose -f docker-compose.prod.yml run --rm profiles_project sh -c "python manage.py collectstatic --no-input --clear"

# Configure supervisor
cp $PROJECT_BASE_PATH/deploy/supervisor_profiles_api.conf /etc/supervisor/conf.d/profiles_api.conf
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart profiles_api

echo "DONE! :)"
