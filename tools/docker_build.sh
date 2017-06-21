#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CACHEDIR2=$DIR/../app/cache/
CACHEDIR3=$DIR/../var/cache/

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOTDIR=$DIR/../

# Need privilege
echo $'\e[33mNeed sudo to delete symfony cache\e[0m'
sudo chown -R $USER $ROOTDIR

# delete symfony cache
echo 'Deleting symfony cache...'

if [ -d "$CACHEDIR2" ]
then
    rm -rf $CACHEDIR2
    echo $'\e[42m'"Cache deleted in $CACHEDIR2"$'\e[0m'
else
    echo $'\e[41m'"$CACHEDIR2 folder not found!"$'\e[0m'
fi
if [ -d "$CACHEDIR3" ]
then
    rm -rf $CACHEDIR3
    echo $'\e[42m'"Cache deleted in $CACHEDIR3"$'\e[0m'
else
    echo $'\e[41m'"$CACHEDIR3 folder not found!"$'\e[0m'
fi

echo 'Launching docker build...'
docker-compose build