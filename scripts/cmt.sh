#!/bin/zsh

fullpath=$(pwd)
subpath=${fullpath#*Yapp}
cdpath="/root/workarea/Yapp$subpath"

echo $cdpath
sudo docker exec --workdir $cdpath bosscontainer /bin/zsh -c "source /root/setup.sh && cmt $@"
