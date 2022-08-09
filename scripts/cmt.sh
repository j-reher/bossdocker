#!/bin/bash

fullpath=$(pwd)
subpath=${fullpath#*Yapp}
cdpath="/root/workarea/Yapp$subpath"

echo $cdpath
docker exec --workdir $cdpath bosscontainer bash -c "source /root/setup.sh && cmt $@"