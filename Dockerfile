FROM tropicloud/np-stack
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD . /usr/local/wps
RUN chmod +x /usr/local/wps/wp-stack && ln -s /usr/local/wps/wp-stack /usr/bin/wps
RUN chmod +x /usr/local/wps/func/wps-mail && ln -s /usr/local/wps/wp-stack /usr/bin/wps-mail
ENV TERM=xterm

EXPOSE 80 443
ENTRYPOINT ["/bin/bash"] 
CMD ["wps","start"]