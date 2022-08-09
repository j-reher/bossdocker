#!/bin/bash

fullpath=$(pwd)
mount=${fullpath%Yapp*}

docker run -dt --security-opt label=disable -v $mount:/root/workarea --name bosscontainer --init --privileged boss