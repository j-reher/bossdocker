#!/bin/bash

fullpath=$(pwd)
temp=${fullpath#*workarea}
subpath=${temp%/*}
cdpath="/root/workarea/$subpath"

echo $cdpath
docker exec --workdir $cdpath bosscontainer bash -c "source /root/setup.sh && cmt $* && chown -R $(id -u):$(id -g) /root/workarea"