FROM bossdocker-base:latest

RUN mkdir -p /root/cmthome && curl https://ep1.rub.de/~jreher/bossdocker-download/cmthome/cmthome-7.0.5.tar.gz | tar xzf - -C /
RUN mkdir -p /workarea/TestRelease && curl https://ep1.rub.de/~jreher/bossdocker-download/testrelease/TestRelease-7.0.5.tar.gz | tar xzf - -C /
RUN mkdir -p /var/cvmfs && curl https://ep1.rub.de/~jreher/bossdocker-download/cache/cvmfs-cache-7.0.5.tar.gz | tar xzf - -C /

RUN echo "source /root/cmthome/setupCMT.sh" >> /root/setup.sh && \
    echo "source /root/cmthome/setup.sh" >> /root/setup.sh && \
    cp /root/workarea/TestRelease/TestRelease-*/cmt/setup.sh setupTestRelease.sh && \
    echo "source /root/setupTestRelease.sh" >> /root/setup.sh && \
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