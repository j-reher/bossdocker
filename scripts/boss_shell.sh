#!/bin/bash

fullpath=$(pwd)
temp=${fullpath#*workarea}
subpath=${temp%/*}
cdpath="/root/workarea$subpath"

sudo docker exec -it --workdir $cdpath bosscontainer bash