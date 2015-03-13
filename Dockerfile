FROM tropicloud/np-stack
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD . /usr/local/wps
RUN /bin/bash /usr/local/wps/wp-stack setup

EXPOSE 80 443
CMD ["wps","start"]