FROM jemtchou/boss

USER root

WORKDIR /root

RUN yum install -y glibc-devel tail && \
    echo "source /root/cmthome/setupCMT.sh" >> /root/setup.sh && \
    echo "source /root/cmthome/setup.sh" >> /root/setup.sh && \
    cp /root/workarea/TestRelease/TestRelease-*/cmt/setup.sh setupTestRelease.sh && \
    echo "source /root/setupTestRelease.sh" >> /root/setup.sh && \
    echo "mount -a" >> /root/mount.sh && \
    echo "#!/bin/bash" >> /root/dockerinit.sh && \
    echo "mount -a" >> /root/dockerinit.sh && \
    echo "bash -i" >> /root/dockerinit.sh && \
    chmod u+x /root/dockerinit.sh && \
    echo "if mountpoint -q /cvmfs/bes3.ihep.ac.cn/ ; then" >> /root/.bashrc && \ 
    echo "source /root/setup.sh" >> /root/.bashrc && \
    echo "fi" >> /root/.bashrc && \
    echo "alias l='ls -ltrhB'" >> /root/.bashrc

# RUN yum install -y gcc git && \
#     git clone https://github.com/ncopa/su-exec.git && \
#     cd su-exec && \
#     make && \
#     mv su-exec /usr/local/bin/ && \
#     cd .. && \
#     rm -rf su-exec && \
#     yum remove -y gcc git

RUN mkdir /data

WORKDIR /root/workarea
ENTRYPOINT [ "bash","-ic" ]
CMD [ "/root/dockerinit.sh" ]