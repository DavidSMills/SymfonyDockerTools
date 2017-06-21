#!/bin/bash
# Launch symfony command to install assets

docker-compose run onestock php /var/www/symfony2/app/console assets:install

docker-compose run onestock php /var/www/symfony2/app/console assetic:dump

docker-compose run onestock php /var/www/symfony2/app/console cache:clear

