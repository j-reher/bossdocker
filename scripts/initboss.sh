#!/bin/zsh

fullpath=$(pwd)
mount=${fullpath%Yapp*}

sudo docker run -d --security-opt label=disable -v $mount:/root/workarea --name bosscontainer --privileged bossdev /bin/zsh -c "source /root/mount.sh && tail -f /dev/null"
