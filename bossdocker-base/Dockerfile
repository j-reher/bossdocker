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

CMD ["/bin/bash"]