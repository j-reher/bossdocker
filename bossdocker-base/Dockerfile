# syntax=docker/dockerfile:1.3-labs
FROM centos:centos7.8.2003

WORKDIR /root

# <--- Install dependencies --->
RUN yum -y install wget fuse libXpm libXi openmotif openmotif-devel compat-libf2c-34 mesa-libGLU openssl098e procmail && \
    yum -y install make glibc-devel && \
    wget -N -P /etc/yum.repos.d/ http://cvmrepo.web.cern.ch/cvmrepo/yum/cernvm.repo && \
    wget -N -P /etc/pki/rpm-gpg/ http://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM && \
    yum -y install cvmfs cvmfs-config-default && \
    yum -y clean all && \
    rm -rf /var/cache/yum

# <--- Configure CernVM-FS --->
RUN echo 'CVMFS_REPOSITORIES=boss.cern.ch' > /etc/cvmfs/default.local && \
    echo "CVMFS_HTTP_PROXY=DIRECT" >> /etc/cvmfs/default.local && \
    echo 'CVMFS_CACHE_BASE=/var/cvmfs/cache' >> /etc/cvmfs/default.local && \
    echo 'CVMFS_QUOTA_LIMIT=10240' >> /etc/cvmfs/default.local && \
    mkdir /etc/cvmfs/keys/ihep.ac.cn

COPY external/ihep.ac.cn.pub /etc/cvmfs/keys/ihep.ac.cn/
COPY external/ihep-2.ac.cn.pub /etc/cvmfs/keys/ihep.ac.cn/
COPY external/ihep-3.ac.cn.pub /etc/cvmfs/keys/ihep.ac.cn/
COPY external/ihep.ac.cn.conf /etc/cvmfs/domain.d/
COPY external/cern.ch.local /etc/cvmfs/

COPY external/systemctl.py /usr/bin/systemctl

RUN chmod a+x /usr/bin/systemctl && \
    cvmfs_config setup && \
    mkdir /cvmfs/bes3.ihep.ac.cn && \
    echo "bes3.ihep.ac.cn        /cvmfs/bes3.ihep.ac.cn   cvmfs" >> /etc/fstab && \
    mkdir /root/workarea && \
    mkdir /root/cmthome && \
    echo "alias l='ls -ltrhB'" >> /root/.bashrc

# COPY cmthome /root/cmthomes

RUN --security=insecure mount -a && \
    cp -r /cvmfs/bes3.ihep.ac.cn/bes3sw/cmthome/cmthome-7.0.5-Slc6Centos7Compat/* /root/cmthome/ && \
    cd /root/cmthome && \
    ls -ltrhB && \
    sed -i 's/#macro WorkArea \"\/home\/bes\/maqm\/workarea\"/macro WorkArea \"\/root\/workarea\"/g' /root/cmthome/requirements && \
    source /root/cmthome/setupCMT.sh && \
    pwd && \
    cmt config && \
    cp -r /cvmfs/bes3.ihep.ac.cn/bes3sw/Boss/7.0.5/TestRelease /root/workarea/ && \
    sed -i 's/#include \"\$BESEVENTMIXERROOT\/share\/jobOptions_EventMixer_rec.txt\"/\/\/#include \"\$BESEVENTMIXERROOT\/share\/jobOptions_EventMixer_rec.txt\"/g' /root/workarea/TestRelease/TestRelease-*/run/jobOptions_rec.txt

# ---> Fill Cache! <---

RUN --security=insecure mount -a && \
    source /root/cmthome/setupCMT.sh && \
    source /root/cmthome/setup.sh && \
    cd /root/workarea/TestRelease/TestRelease-00-00-92/cmt && \
    cmt clean && cmt config && cmt make && \
    source /root/workarea/TestRelease/TestRelease-*/cmt/setup.sh && \
    cd /root/workarea/TestRelease/TestRelease-00-00-92/run && \
    boss.exe jobOptions_sim.txt && \
    boss.exe jobOptions_rec.txt && \
    boss.exe jobOptions_ana_rhopi.txt

# <--- Setup Environment --->
RUN echo "source /root/cmthome/setupCMT.sh" >> /root/setup.sh && \
    echo "source /root/cmthome/setup.sh" >> /root/setup.sh && \
    cp /root/workarea/TestRelease/TestRelease-*/cmt/setup.sh setupTestRelease.sh && \
    echo "source /root/setupTestRelease.sh" >> /root/setup.sh && \
    echo "mount -a" >> /root/mount.sh && \
    echo "#!/bin/bash" >> /root/dockerinit.sh && \
    echo "mount -a" >> /root/dockerinit.sh && \
    echo "bash -i" >> /root/dockerinit.sh && \
    chmod u+x /root/dockerinit.sh && \
    echo "if [ -n \"$(ls -A /cvmfs/bes3.ihep.ac.cn 2>/dev/null)\" ] ; then" >> /root/.bashrc && \
    echo "    echo \"CernVM-FS found\"" >> /root/.bashrc && \
    echo "else" >> /root/.bashrc && \
    echo "    source /root/setup.sh" >> /root/.bashrc && \
    echo "fi" >> /root/.bashrc && \
    echo "alias l='ls -ltrhB'" >> /root/.bashrc

WORKDIR /root/workarea
ENTRYPOINT [ "bash","-ic" ]
CMD [ "/root/dockerinit.sh" ]