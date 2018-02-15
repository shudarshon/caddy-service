#!/bin/bash

#install caddyserver & supervisor
curl https://getcaddy.com | bash -s personal http.cache,http.expires,http.git,http.minify,http.nobots,http.proxyprotocol,http.realip,http.upload
sudo apt-get install supervisor -y

#allow caddy to use privileged port (80,443)
sudo setcap cap_net_bind_service=+ep `which caddy`

#create necessary directories for caddy and supervisor script
sudo mkdir -p /etc/caddy/ssl
sudo mkdir -p /var/log/{supervisor,caddy}

#create empty file for caddy configuration and log
sudo touch /etc/caddy/Caddyfile
sudo touch /var/log/supervisor/caddy.log
sudo touch /var/log/caddy/{access,error}.log

#change ownership of directories and log file
sudo chown www-data:www-data /etc/caddy/ssl
sudo chown www-data:root /var/log/supervisor/caddy.log
sudo chown www-data:www-data /var/log/caddy/{access,error}.log
