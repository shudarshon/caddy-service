#!/bin/bash

#Create necessary directories for caddy
sudo mkdir -p /var/www /etc/caddy /etc/ssl/caddy

#Install Caddy
curl https://getcaddy.com | bash -s personal

#Allow caddy to use port 80,443
sudo setcap cap_net_bind_service=+ep `which caddy`

# Create Caddy config file
sudo touch /etc/caddy/Caddyfile

#Change permission and ownership
sudo chown -R  www-data:www-data /var/www
sudo chown -R  www-data:root /etc/ssl/caddy
sudo chown root:www-data /etc/caddy

#Copy caddy systemd script and restart service
sudo cp caddy.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable caddy.service
sudo systemctl start caddy.service
