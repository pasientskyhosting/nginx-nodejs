FROM node:11.12.0-alpine
MAINTAINER Andreas Krüger <ak@patientsky.com>

RUN apk add --no-cache bash \
    supervisor \
    tzdata \
    nginx && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /var/www/html/

ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx-site.conf /etc/nginx/sites-enabled/default.conf

# Add Scripts
ADD scripts/start.sh /start.sh

# copy in code
ADD errors /var/www/errors/

EXPOSE 80

CMD ["/bin/bash","/start.sh"]
