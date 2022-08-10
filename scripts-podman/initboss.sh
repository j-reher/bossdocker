#!/bin/bash

fullpath=$(pwd)
mount=${fullpath%Yapp*}

podman run --rm -dt --security-opt label=disable -v "$mount":/root/workarea --name bosscontainer --init --privileged jreher/boss