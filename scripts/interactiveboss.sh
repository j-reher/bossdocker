#!/bin/bash

fullpath=$(pwd)
mount=${fullpath%Yapp*}
subpath=${fullpath#*Yapp}
cdpath="/root/workarea/Yapp$subpath"

docker run --security-opt label=disable -it --rm -v $mount:/root/workarea --workdir $cdpath --privileged boss