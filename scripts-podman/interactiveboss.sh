#!/bin/bash

fullpath=$(pwd)
mount=${fullpath%workarea*}
subpath=${fullpath#*workarea}
cdpath="/root/workarea/Yapp$subpath"

podman run --security-opt label=disable -it --rm -v "$mount":/root/workarea --workdir "$cdpath" --privileged jreher/boss