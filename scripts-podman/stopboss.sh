#!/bin/bash

CONTAINERNAME="bosscontainer-$(id -un)"

CLEARCACHES=0

SHORT=h
LONG=clearcaches,help
OPTS=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")

eval set -- "$OPTS"

while :
do
    case "$1" in
        --clearcaches )
            CLEARCACHES=1
            shift
            ;;
        -h | --help )
            echo "Usage: $0 [-h]"
            echo "  -h              Show this help"
            exit 0
            ;;
        -- )
            shift;
            break
            ;;
        * )
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if podman container inspect "$CONTAINERNAME" >& /dev/null ; then
podman stop "$CONTAINERNAME" >& /dev/null && echo "Boss container was stopped successfully."
fi

VOLUMES=$(podman volume ls -qf name="cvmfs_cache_$(id -un)_")
if [ $CLEARCACHES == 1 ] && [ "$VOLUMES" != "" ] ; then
    podman volume rm $VOLUMES >& /dev/null && printf 'Removed the following CVMFS cache volumes:\n%-s\n' "$VOLUMES"
fi