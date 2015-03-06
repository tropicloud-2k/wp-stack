FROM tropicloud/np-stack
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD . /usr/local/wps
RUN chmod +x /usr/local/wps/wp-stack && ln -s /usr/local/wps/wp-stack /usr/local/bin/wps

EXPOSE 80 443
CMD ["wps","start"]