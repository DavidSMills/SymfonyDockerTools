#!/bin/bash
# Install/update symfony env
# WARNING in prod you have to create bdd

set -e

# First command argument is environment
if [ $# -eq 0 ]
then
    ENV=dev
else
    ENV=$1
fi

echo $ENV
export SYMFONY_ENV=$ENV

# Check if composer is installed
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRCDIR=$DIR/../

if [ ! -f "$SRCDIR/composer.phar" ]
then
    # No composer found, download itrproods
    echo $'\e[46m***** Downloading composer.phar...\e[0m'
    wget https://getcomposer.org/composer.phar -O $SRCDIR/composer.phar
fi

echo $'\e[46m***** Launch composer install\e[0m'

if [ $ENV = dev ]
then
    docker-compose run onestock php /var/www/symfony2/composer.phar install
else
    docker-compose run onestock php /var/www/symfony2/composer.phar install --no-dev --optimize-autoloader
fi
echo $'\e[46m***** Done\e[0m'

# Build bdd
if [ ! $ENV = prod ]
then
    echo $'\e[46m***** Droping database...\e[0m'
    read -p $'Drop and create new database [y/n]?' answer
    case ${answer:0:1} in
        y|Y )
            docker-compose run onestock php /var/www/symfony2/app/console doctrine:schema:drop --env=$ENV --force
            echo $'\e[46m***** Done\e[0m'

            echo $'\e[46m***** Creating new database...\e[0m'
            docker-compose run onestock php /var/www/symfony2/app/console doctrine:schema:create --env=$ENV

        ;;
        * )
        ;;
    esac
    echo $'\e[46m***** Done\e[0m'
fi

# Update bdd
echo $'\e[46m***** Updating bdd schema\e[0m'
docker-compose run onestock php /var/www/symfony2/app/console doctrine:schema:update --env=$ENV --force
echo $'\e[46m***** Done\e[0m'

# Adding fixture
if [ ! $ENV = prod ]
then
    echo $'\e[46m***** Adding fixture...\e[0m'
    read -p $'Add fixtures [y/n]?' answer2
    case ${answer2:0:1} in
        y|Y )
            docker-compose run onestock php /var/www/symfony2/app/console doctrine:fixture:load --env=$ENV
        ;;
        * )
        ;;
    esac
    echo $'\e[46m***** Done\e[0m'
fi

# Install assets
echo $'\e[46m***** Assets deployement...\e[0m'
docker-compose run onestock php /var/www/symfony2/app/console assets:install --env=$ENV
docker-compose run onestock php /var/www/symfony2/app/console assetic:dump --env=$ENV --no-debug
echo $'\e[46m***** Done\e[0m'

# Clear cache
echo $'\e[46m***** Clearing cache...\e[0m'
docker-compose run onestock php /var/www/symfony2/app/console cache:clear --env=$ENV --no-debug

echo $'\e[46m***** Finish! Enjoy man\e[0m'
