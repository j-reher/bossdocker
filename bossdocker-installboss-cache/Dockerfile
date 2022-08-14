ARG REPOSITORY=""

FROM ${REPOSITORY}jreher/boss:utils-install

LABEL org.opencontainers.image.version="2.0.0" \
      org.opencontainers.image.title="BOSS Utilities" \
      org.opencontainers.image.vendor="Jan Reher" \
      org.opencontainers.image.description="BOSS image utilities" \
      org.opencontainers.image.authors="Jan Reher <j.reher@icloud.com>" \
      org.opencontainers.image.url="github.com/jreher/boss" \
      org.opencontainers.image.source="github.com/jreher/boss" \
      org.opencontainers.image.license="GP-3.0" \
      org.opencontainers.image.os="Linux" \
      org.opencontainers.image.base.digest="sha256:50b9a3bc27378889210f88d6d0695938e45a912aa99b3fdacfb9a0fef511f15a" \
      org.opencontainers.image.base.name="docker.io/centos:centos7.8.2003" \
      org.opencontainers.image.base.version="7.8.2003"

COPY cachemaker.sh /root/cachemaker.sh
RUN chmod a+x /root/cachemaker.sh

ENTRYPOINT [ "/root/cachemaker.sh" ]