#!/bin/bash

mkdir -p "$(pwd)"/output
rm -rf "$(pwd)"/output/*

while IFS="" read -r p || [ -n "$p" ]
do
    ssh -q pc51.ep1.rub.de [[ -f "/home/tau/jreher/WWW/bossdocker-download/cmthome/cmthome-$p.tar.gz" ]] && \
    ssh -q pc51.ep1.rub.de [[ -f "/home/tau/jreher/WWW/bossdocker-download/cache/cvmfs-cache-$p.tar.gz" ]] && \
    ssh -q pc51.ep1.rub.de [[ -f "/home/tau/jreher/WWW/bossdocker-download/testrelease/TestRelease-$p.tar.gz" ]] && \
    continue
    printf 'Processing Version \"%s\"\n' "$p"
    docker run --rm -v "$(pwd)/output:/out" --privileged bossdocker-installboss-cache:latest "$p" "$(id -u):$(id -g)"
done <versions.txt

scp output/cmthome-*.tar.gz pc51.ep1.rub.de:/home/tau/jreher/WWW/bossdocker-download/cmthome/ || :
scp output/TestRelease-*.tar.gz pc51.ep1.rub.de:/home/tau/jreher/WWW/bossdocker-download/testrelease/ || :
scp output/cvmfs-cache-*.tar.gz pc51.ep1.rub.de:/home/tau/jreher/WWW/bossdocker-download/cvmfs-cache/ || :