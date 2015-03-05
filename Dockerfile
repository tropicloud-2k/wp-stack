FROM tropicloud/np-stack
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD . /usr/local/wps
ENV DB_HOST="" DB_PORT="" DB_NAME="" DB_USER="" DB_PASS=""
RUN chmod +x /usr/local/wps/wp-stack && ln -s /usr/local/wps/wp-stack /usr/bin/wps

EXPOSE 80 443
ENTRYPOINT ["wps"] 
CMD ["start"]