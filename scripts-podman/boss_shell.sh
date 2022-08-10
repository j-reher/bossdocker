#!/bin/bash

fullpath=$(pwd)
subpath=${fullpath#*workarea}
cdpath="/root/workarea$subpath"

podman exec -it --workdir "$cdpath" bosscontainer bash