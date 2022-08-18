#!/bin/bash

CONTAINERNAME="bosscontainer-$(id -un)"

if ! podman container inspect "$CONTAINERNAME" >& /dev/null ; then
    echo "Boss container is not running!"
    exit 1
fi

CDPATH="/root/workarea"

VOLUMESTRING="$(podman inspect -f '{{ .Mounts }}' $CONTAINERNAME)"
TEMPSTRING1=${VOLUMESTRING#*\{bind}
TEMPSTRING2=${TEMPSTRING1%/root*}
WORKAREA="$(echo "$TEMPSTRING2" | awk '{$1=$1}1')"

if [ -d "$WORKAREA" ] ; then
    CWD=$(pwd)
    SUBDIR=${CWD#*"$WORKAREA"}
    if [ "$SUBDIR" != "$CWD" ] ; then
        CDPATH="/root/workarea/$SUBDIR"
    fi
fi

podman exec -it --workdir "$CDPATH" "$CONTAINERNAME" bash