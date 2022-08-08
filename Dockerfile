FROM jemtchou/boss

USER root

WORKDIR /root

RUN yum install -y zsh git sudo
RUN yum groupinstall -y 'Development Tools'

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN echo "/usr/bin/zsh" >> /etc/shells
RUN chsh root --shell /usr/bin/zsh

RUN echo "source /root/cmthome/setupCMT.sh" >> /root/setup.sh
RUN echo "source /root/cmthome/setup.sh" >> /root/setup.sh
RUN echo "mount -a" >> /root/mount.sh

RUN mkdir .workarea_backup
RUN cp -r workarea/* .workarea_backup/

RUN echo "alias l='ls -ltrhB'" >> /root/.zshrc

WORKDIR /root/workarea
#CMD ["/usr/bin/zsh", "-c", "source /root/.zshrc", "-c"]
CMD ["tail -f /dev/null"]
