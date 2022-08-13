#!/bin/bash

container_version=${1:-latest}

fullpath=$(pwd)
mount=${fullpath%Yapp*}
printf 'Starting jreher/boss:%s\ and mounting %s as workarea\n' "$container_version" "$mount"

docker run --rm -dt --security-opt label=disable -v "$mount":/root/workarea --name bosscontainer --init --privileged "jreher/boss:$container_version"
