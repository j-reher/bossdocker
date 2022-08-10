#!/bin/bash

fullpath=$(pwd)
subpath=${fullpath#*workarea}
cdpath="/root/workarea$subpath"

docker exec --workdir "$cdpath" bosscontainer bash -c "source /root/setup.sh && boss.exe $* && chown -R $(id -u):$(id -g) $cdpath"