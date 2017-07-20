#!/bin/bash

#install caddyserver & supervisor
curl https://getcaddy.com | bash
apt-get install supervisor -y

#allow caddy to use privileged port (80,443)
setcap cap_net_bind_service=+ep `which caddy`

#create necessary directories for caddy and supervisor script
mkdir -p /etc/caddy/ssl
mkdir -p /var/log/supervisor /var/log/caddy

#create empty file for caddy configuration and log
touch /etc/caddy/Caddyfile
touch /var/log/supervisor/caddy.log
touch /var/log/caddy/{access,error}.log

#change ownership of directories and log file
chown www-data:www-data /etc/caddy/ssl
chown www-data:www-data /var/log/supervisor/caddy.log
chown www-data:www-data /var/log/caddy/{access,error}.log
