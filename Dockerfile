FROM centos:centos7
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD wps /usr/local/wps
ENV DB_HOST=$(echo $DATABASE_URL | grep -o @.* | cut -d: -f1 | sed 's/@//g')
ENV DB_PORT=$(echo $DATABASE_URL | grep -o @.* | cut -d: -f2 | cut -d/ -f1 )

RUN chmod u+x /usr/local/wps/wps.sh && ln -s /usr/local/wps/wps.sh /usr/bin/wps
RUN wps setup

EXPOSE 80 443
CMD ["wps start"]
