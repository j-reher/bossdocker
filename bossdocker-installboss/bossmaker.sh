#!/bin/bash

version=${1:-7.0.5}
cmthome="/cvmfs/bes3.ihep.ac.cn/bes3sw/cmthome/cmthome-$version"
ugid=${2:-"$(id -u):$(id -g)"}

mount -a

compathome=$cmthome-Slc6Centos7Compat
[ -d "$compathome" ] && printf 'appending -Slc6Centos7Compat to cmthome!\n' && cmthome=$compathome

[ ! -d "$cmthome" ] && printf '\nERROR: BOSS Version %s not found!\nAvailable Versions:\n' "$version" && \
    /bin/ls -m /cvmfs/bes3.ihep.ac.cn/bes3sw/cmthome/ | sed 's/cmthome-//g' && \
    printf "\nAttention: Only Versions compatible with Centos7 will work!\nUse -Slc6Centos7Compat whenever available." && \
    exit 1

printf '\nCopy %s to cmthome\n' "$cmthome"
cp -r "$cmthome"/* /root/cmthome/
printf "\nMake Adjustments to cmthome/requirements\n"
sed -i 's@#macro WorkArea.*@macro WorkArea "/root/workarea"@' /root/cmthome/requirements
sed -i 's/#path_remove/path_remove/g' /root/cmthome/requirements
sed -i 's/#path_prepend/path_prepend/g' /root/cmthome/requirements
printf "\nConfigure CMT\n"
source /root/cmthome/setupCMT.sh
cd /root/cmthome || exit 1
cmt config

printf "\nInstall TestRelease\n"
cp -r "/cvmfs/bes3.ihep.ac.cn/bes3sw/Boss/$version/TestRelease" /root/workarea/
sed -i 's/#include \"\$BESEVENTMIXERROOT\/share\/jobOptions_EventMixer_rec.txt\"/\/\/#include \"\$BESEVENTMIXERROOT\/share\/jobOptions_EventMixer_rec.txt\"/g' /root/workarea/TestRelease/TestRelease-*/run/jobOptions_rec.txt

printf "\nTar up cmthome\n"
tar cvzf "/out/cmthome-$version.tar.gz" /root/cmthome
chown "$ugid" "/out/cmthome-$version.tar.gz"
printf "\nArchive TestRelease\m"
tar cvzf "/out/TestRelease-$version.tar.gz" /root/workarea/TestRelease
chown "$ugid" "/out/TestRelease-$version.tar.gz"