#!/bin/bash
# Launch symfony command given in arguments

CONTAINER=`docker-compose ps | grep php | awk '{print $1}'`

docker exec -it $CONTAINER php /var/www/symfony/app/console $*
