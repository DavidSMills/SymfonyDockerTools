#!/bin/bash
# search for a name container and execute it with docker bash cmd
# usage : ./exec.sh php|mysql|nginx

SEARCH=$1
CONTAINER="$(docker ps | grep $SEARCH)"
PID=${CONTAINER:0:12}

docker exec -it $PID bash