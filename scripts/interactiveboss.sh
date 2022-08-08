#!/bin/zsh

fullpath=$(pwd)
mount=${fullpath%Yapp*}
subpath=${fullpath#*Yapp}
cdpath="/root/workarea/Yapp$subpath"

sudo docker run --security-opt label=disable -it -v $mount:/root/workarea --workdir $cdpath --privileged bossdev zsh
