#!/bin/bash

fullpath=$(pwd)
subpath=${fullpath#*workarea}
cdpath="/root/workarea$subpath"

sudo docker exec -it --workdir $cdpath bosscontainer bash