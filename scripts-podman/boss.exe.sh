#!/bin/bash

fullpath=$(pwd)
subpath=${fullpath#*workarea}
cdpath="/root/workarea$subpath"

podman exec --workdir "$cdpath" bosscontainer bash -c "source /root/setup.sh && boss.exe $*"