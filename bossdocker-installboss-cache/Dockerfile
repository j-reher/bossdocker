FROM bossdocker-installboss:latest

COPY cachemaker.sh /root/cachemaker.sh
RUN chmod a+x /root/cachemaker.sh

ENTRYPOINT [ "/root/cachemaker.sh" ]