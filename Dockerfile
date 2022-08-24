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

RUN mkdir -p /root/cmthome && curl http://boss.janreher.de/cmthome/cmthome-$BOSS_VERSION.tar.gz | tar xzf - -C /
RUN mkdir -p /workarea/TestRelease && curl http://boss.janreher.de/testrelease/TestRelease-$BOSS_VERSION.tar.gz | tar xzf - -C /
RUN mkdir -p /var/cvmfs && curl http://boss.janreher.de/cache/cvmfs-cache-$BOSS_VERSION.tar.gz | tar xzf - -C /

RUN yum -y install libXpm-devel libXi-devel && \
    yum -y clean all && \
    rm -rf /var/cache/yum

ADD inputs/dockerinit.sh /root/dockerinit.sh
ADD inputs/setup.sh /root/setup.sh
ADD inputs/mount.sh /root/mount.sh

RUN cp /root/workarea/TestRelease/TestRelease-*/cmt/setup.sh setupTestRelease.sh && \
    cp -r /root/workarea/TestRelease/ /root/TestRelease && \
    chmod u+x /root/dockerinit.sh && \
    # echo "    source /root/mount.sh" >> /root/.bashrc && \
    # echo "    source /root/setup.sh" >> /root/.bashrc && \
    echo "alias l='ls -ltrhB'" >> /root/.bashrc

WORKDIR /root/workarea
ENTRYPOINT [ "bash","-ic" ]
CMD [ "/root/dockerinit.sh" ]