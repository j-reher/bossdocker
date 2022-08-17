#!/bin/bash

if ! docker container inspect bosscontainer >& /dev/null ; then
    echo "Boss container is not running!"
    exit 1
fi

VOLUMESTRING="$(docker inspect -f '{{ .Mounts }}' bosscontainer)"
TEMPSTRING1=${VOLUMESTRING#*bind}
TEMPSTRING2=${TEMPSTRING1%/root*}
WORKAREA="$(echo "$TEMPSTRING2" | awk '{$1=$1}1')"

if [ ! -d "$WORKAREA" ] ; then
    echo "ERROR: Workarea not set!"
    exit 1
fi

CWD=$(pwd)
SUBDIR=${CWD#*"$WORKAREA"}

if [ "$SUBDIR" == "$CWD" ] ; then
    echo "ERROR: Current directory is not within workarea!"
    exit 2
fi

CDPATH="/root/workarea/$SUBDIR"

docker exec --workdir "$CDPATH" bosscontainer bash -c "source /root/setup.sh && boss.exe $* && chown -R $(id -u):$(id -g) $CDPATH"