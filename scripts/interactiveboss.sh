#!/bin/bash

container_version="version=${1:-latest}"

fullpath=$(pwd)
mount=${fullpath%workarea*}
subpath=${fullpath#*workarea}
cdpath="/root/workarea/Yapp$subpath"

docker run --security-opt label=disable -it --rm -v "$mount":/root/workarea --workdir "$cdpath" --privileged "jreher/boss:$container_version"