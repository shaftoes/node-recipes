#!/usr/bin/env bash
set -e
echo "configuring nginx for matrix server"
DOMAIN_NAME=$1
EMAIL_ADDRESS=$2

# mkdir -p /etc/sites-available/$DOMAIN_NAME
mv /tmp/bootstrap/matrix_nginx.conf /etc/nginx/sites-available/$DOMAIN_NAME.conf
ln -s /etc/nginx/sites-available/$DOMAIN_NAME.conf /etc/nginx/sites-enabled/$DOMAIN_NAME.conf
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

certbot certonly --non-interactive --agree-tos --renew-by-default --email $EMAIL_ADDRESS -a webroot --webroot-path=/var/www/html/ -d $DOMAIN_NAME

service nginx reload

# Configure auto-renewals
echo "30 2 * * 1 certbot renew >> /var/log/letsencrypt/letsencrypt.log" >> /etc/crontab
echo "35 2 * * 1 systemctl reload nginx" >> /etc/crontab