ARG REPOSITORY="jreher/"

FROM ${REPOSITORY}boss-utils:base

LABEL org.opencontainers.image.version="2.0.0" \
      org.opencontainers.image.title="BOSS" \
      org.opencontainers.image.vendor="Jan Reher" \
      org.opencontainers.image.description="Docker container to run BesIII Offline Software System on development machines" \
      org.opencontainers.image.authors="Jan Reher <j.reher@icloud.com>" \
      org.opencontainers.image.url="github.com/jreher/boss" \
      org.opencontainers.image.source="github.com/jreher/boss" \
      org.opencontainers.image.license="GP-3.0" \
      org.opencontainers.image.os="Linux" \
      org.opencontainers.image.base.digest="sha256:50b9a3bc27378889210f88d6d0695938e45a912aa99b3fdacfb9a0fef511f15a" \
      org.opencontainers.image.base.name="docker.io/centos:centos7.8.2003" \
      org.opencontainers.image.base.version="7.8.2003"

ARG BOSS_VERSION="7.0.5"

RUN mkdir -p /root/cmthome && curl https://ep1.rub.de/~jreher/bossdocker-download/cmthome/cmthome-$BOSS_VERSION.tar.gz | tar xzf - -C /
RUN mkdir -p /workarea/TestRelease && curl https://ep1.rub.de/~jreher/bossdocker-download/testrelease/TestRelease-$BOSS_VERSION.tar.gz | tar xzf - -C /
RUN mkdir -p /var/cvmfs && curl https://ep1.rub.de/~jreher/bossdocker-download/cache/cvmfs-cache-$BOSS_VERSION.tar.gz | tar xzf - -C /

RUN cp /root/workarea/TestRelease/TestRelease-*/cmt/setup.sh setupTestRelease.sh && \
    echo "source /root/cmthome/setupCMT.sh" >> /root/setup.sh && \
    echo "source /root/cmthome/setup.sh" >> /root/setup.sh && \
    echo "source /root/setupTestRelease.sh" >> /root/setup.sh && \
    echo "export WORKAREA=/root/workarea" >> /root/setup.sh && \
    echo "if [ ! -n \"\$(ls -A /cvmfs/bes3.ihep.ac.cn 2>/dev/null)\" ] ; then" >> /root/mount.sh && \
    echo "    mount -a" >> /root/mount.sh && \
    echo "fi" >> /root/mount.sh && \
    echo "#!/bin/bash" >> /root/dockerinit.sh && \
    echo "source /root/mount.sh" >> /root/dockerinit.sh && \
    echo "source /root/setup.sh" >> /root/dockerinit.sh && \
    echo "bash -i" >> /root/dockerinit.sh && \
    chmod u+x /root/dockerinit.sh && \
    # echo "    source /root/mount.sh" >> /root/.bashrc && \
    # echo "    source /root/setup.sh" >> /root/.bashrc && \
    echo "alias l='ls -ltrhB'" >> /root/.bashrc

WORKDIR /root/workarea
ENTRYPOINT [ "bash","-ic" ]
CMD [ "/root/dockerinit.sh" ]