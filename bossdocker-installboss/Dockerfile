FROM bossdocker-base:latest

RUN mkdir /out
COPY bossmaker.sh /root/bossmaker.sh
RUN chmod a+x /root/bossmaker.sh

ENTRYPOINT [ "/root/bossmaker.sh" ]