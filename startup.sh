#!/bin/bash
envsubst < /etc/oauth2proxy.conf.template > /etc/oauth2proxy.conf
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf