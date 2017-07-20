## Setting Up Caddy Web Server with Supervisor ##

Caddy is the HTTP/2 web server with automatic HTTPS which is easy to configure and use. Supervisor is a process control and monitoring system. The benefits of using supervisor are: reboot safe execution, automatic restart after crashes and execution as a non-root user.

In order to run caddy server we need to setup caddy server first. Then we need to configure directories, configuration files, log files and permissions. I have created a script (**provision.sh**) which will manage the configuration files, directories and permission.

```
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
```

**www-data** user is the de-facto standard for web server user permission. Now we need to change the empty **Caddyfile** with proper configuration. A very simple reverse proxy caddy script looks like

```
domain.com {

root /var/www/app_dir

gzip

proxy /app1_dir localhost:5000
proxy /app2_dir localhost:6000
proxy /app3_dir localhost:7000

log /var/log/caddy/access.log
errors /var/log/caddy/error.log

#this option will allow you to debug
errors visible

}
```

The content of **Caddyfile** in ``/etc/caddy/Caddyfile`` file should be replaced with the above code as per your configuration.

Next task is to ensure that caddy server runs background when operating system reboots or takes restart automatically when server will crash. We will create a supervisor script to accomplish this scenario.

```
$ sudo touch /etc/supervisor/conf.d/caddy.configuration
```

Next, replace the empty file with following configuration.

```
[program:caddy]
command=/usr/local/bin/caddy -agree=true -email=admin@domain.com -conf=/etc/caddy/Caddyfile
environment=CADDYPATH=/etc/caddy/ssl
directory=/var/log/caddy
user=www-data
stdout_logfile=/var/log/supervisor/caddy.log
stderr_logfile=/var/log/supervisor/caddy.log
autostart=true
autorestart=true
startsecs=10
stopwaitsecs=600
startretries=3
```

Make sure that you change the email address accordingly. After that make supervisor run tcaddy server.

```
$ sudo supervisorctl reread
$ sudo supervisorctl update
$ sudo supervisorctl status

```

After sometime the supervisor caddy server status will change from **STARTING** to **RUNNING**.
