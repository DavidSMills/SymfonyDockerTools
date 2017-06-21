#!/bin/bash
#Install composer and stuff

#download composer

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CONTAINER=`docker-compose ps | grep php | awk '{print $1}'`

SRCDIR=$DIR/../symfony/

if [ ! -f "$SRCDIR/composer.phar" ]
then
    echo "Downloading composer.phar..."
    cd $SRCDIR
    curl --remote-name https://getcomposer.org/composer.phar 
    cd -
fi

echo "Launch composer command : composer.phar $*"
docker exec $CONTAINER php /var/www/symfony/composer.phar $*
