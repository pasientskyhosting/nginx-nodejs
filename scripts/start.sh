#!/bin/bash

# Disable Strict Host checking for non interactive git clones
mkdir -p -m 0700 /root/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

if [ -d "/adaptions" ]; then
    # make scripts executable incase they aren't
    chmod -Rf 750 /adaptions/*

    # run scripts in number order
    for i in `ls /adaptions/`; do /adaptions/$i || exit 1; done
fi

# Set node environment
export NODE_ENV=production

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
