FROM centos:centos7
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD wps /usr/local/wps
RUN chmod u+x /usr/local/wps/wps.sh && ln -s /usr/local/wps/wps.sh /usr/bin/wps
RUN wps setup

EXPOSE 80 443
ENTRYPOINT ["/bin/bash"] 
CMD ["wps","start"]