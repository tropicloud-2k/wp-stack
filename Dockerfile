FROM tropicloud/np-stack
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD . /usr/local/wps
RUN chmod +x /usr/local/wps/wps.sh && ln -s /usr/local/wps/wps.sh /usr/bin/wps

EXPOSE 80 443
ENTRYPOINT ["/bin/bash"] 
CMD ["wps","start"]