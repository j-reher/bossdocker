#!/bin/bash

fullpath=$(pwd)
subpath=${fullpath#*workarea}
cdpath="/root/workarea$subpath"

docker exec -it --workdir "$cdpath" bosscontainer bash