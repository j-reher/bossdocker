#!/bin/bash

# Default values:
FULLPATH=$(pwd)
TEMPPATH1=${FULLPATH%Yapp*}
WORKAREA=${TEMPPATH1%TestRelease/*}
PERSISTCACHE=0;
REPOSITORY="";
CONTAINER_VERSION="latest"

SHORT=w:,p,v:,r:,h
LONG=workarea:,persistcache,version:,repository:,help
OPTS=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")

eval set -- "$OPTS"

while :
do
    case "$1" in
        -w | --workarea )
            WORKAREA="$2"
            shift 2
            [ -d "$WORKAREA" ] || { echo "Folder $WORKAREA does not exist!"; exit 1; }
            ;; 
        -p | --persistcache )
            PERSISTCACHE=1
            shift
            ;;
        -r | --repository )
            REPOSITORY="$2"
            shift 2
            ;;
        -v | --version )
            CONTAINER_VERSION="$2"
            shift 2
            ;;
        -h | --help )
            echo "Usage: $0 -w <workarea> [-p]"
            echo "  -w <workarea>    Workarea to use. Default: Parent directory containing Yapp"
            echo "  -v <version>     Version of the container to use. Use a supported BOSS version or \"latest\". Default: latest"
            echo "  -r <repository/> Container repository to use. Omit for docker default repository (usually docker.io)."
            echo "  -p               Persist CVMFS cache next to workarea"
            exit 0
            ;;
        -- )
            shift;
            break
            ;; 
        * )
            echo "Unknown option: $1"
            break
            ;;
    esac
done

if docker container inspect bosscontainer >& /dev/null ; then
    echo "A boss container is already running! Please stop it before starting another."
    exit 1
fi

printf 'Checking if %sjreher/boss:%s is up to date:\n' "$REPOSITORY" "$CONTAINER_VERSION"
docker pull "${REPOSITORY}jreher/boss:$CONTAINER_VERSION" 1> /dev/null

CACHEARG=""
if [ $PERSISTCACHE == 1 ] ; then
    CACHEARG="-v cvmfs_cache_$CONTAINER_VERSION:/var/cvmfs/cache "
    docker volume inspect "cvmfs_cache_$CONTAINER_VERSION" >& /dev/null || echo "Creating cvmfs-cache volume for Version $CONTAINER_VERSION. BOSS might be slow while it's being populated!"
fi


docker run --security-opt label=disable -it --rm $CACHEARG -v "$WORKAREA":/root/workarea --privileged "${REPOSITORY}jreher/boss:$CONTAINER_VERSION"