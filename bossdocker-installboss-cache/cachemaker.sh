#!/bin/bash

version=${1:-7.0.5-Slc6Centos7Compat}
ugid=${2:-"$(id -u):$(id -g)"}

/root/bossmaker.sh "$version" "$ugid"

printf "\nSetup BOSS\n"
source /root/cmthome/setupCMT.sh
source /root/cmthome/setup.sh
source /root/workarea/TestRelease/TestRelease-*/cmt/setup.sh

printf "\nReinstall TestRelease\n"
cd /root/workarea/TestRelease/TestRelease-*/cmt || exit 1
cmt clean
cmt config
cmt make

printf "\nRun BOSS\n"
cd /root/workarea/TestRelease/TestRelease-*/run || exit 1
boss.exe jobOptions_sim.txt
boss.exe jobOptions_rec.txt
boss.exe jobOptions_ana_rhopi.txt

printf "\nArchive cvmfs-cache\n"
tar cvzf "/out/cvmfs-cache-$version.tar.gz" /var/cvmfs/cache
chown "$ugid" "/out/cvmfs-cache-$version.tar.gz"