#!/usr/bin/env bash

set -e

PROJECT_BASE_PATH='/usr/local/apps/profiles-rest-api'

git pull
cd $PROJECT_BASE_PATH
sudo docker-compose -f docker-compose.prod.yml build
sudo docker-compose -f docker-compose.prod.yml run --rm profiles_project sh -c "python manage.py makemigrations profiles_api --noinput"
sudo docker-compose -f docker-compose.prod.yml run --rm profiles_project sh -c "python manage.py collectstatic --no-input --clear"
sudo supervisorctl restart profiles_api

echo "DONE! :)"
