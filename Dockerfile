FROM node:13-slim

LABEL maintainer "Andreas Krüger <ak@patientsky.com>"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y -q --install-recommends --no-install-suggests \
      curl \
      supervisor \
      tzdata \
      git \
      ca-certificates \
      net-tools \
      libjemalloc-dev \
    && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
    && curl -fsSL https://download.newrelic.com/548C16BF.gpg | apt-key add - \
    && echo "deb http://nginx.org/packages/mainline/debian/ stretch nginx" > /etc/apt/sources.list.d/nginx.list \
    && echo "deb-src http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list \
    && apt-get update \
    && apt-get install -y -q --install-recommends --no-install-suggests \
    nginx && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /var/www/html/

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so

ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx-site.conf /etc/nginx/sites-enabled/default.conf

# Add Scripts
ADD scripts/start.sh /start.sh

# copy in code
ADD errors /var/www/errors/

EXPOSE 80

CMD ["/bin/bash","/start.sh"]
