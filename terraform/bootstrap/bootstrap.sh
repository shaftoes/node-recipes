#!/usr/bin/env bash
export DEBIAN_FRONTEND="noninteractive"
set -e

#use googles DNS because DO hates ipv6
sed -i "s/dns-nameservers.*/dns-nameservers 8.8.8.8 8.8.4.4/g" /etc/network/interfaces
sed -i  "s\#precedence ::ffff:0:0/96  100\precedence ::ffff:0:0/96  100\g" /etc/gai.conf
sudo ifdown eth0 && sudo ifup eth0

apt-get update
#ensure pre-requisite commands for add certbot authority are present
if ! [ -x "$(command -v curl)" ]; then apt-get install -y curl; fi
if ! [ -x  "$(command -v software-properties-common)" ]; then apt-get install -y software-properties-common dirmngr; fi 

# add repos for matrix-synapse package
printf "deb http://matrix.org/packages/debian/ stretch main" > /etc/apt/sources.list.d/synapse.list
printf "deb http://ftp.debian.org/debian stretch-backports main"  /etc/apt/sources.list.d/certbot.list
curl -s https://matrix.org/packages/debian/repo-key.asc | apt-key add -

# # add repository for certbot 
# add-apt-repository ppa:certbot/certbot -y

apt-get update

# apt-get install -y  python-certbox-nginx -t stretch-backports

apt-get install -y --allow-unauthenticated nginx \
     postgresql \
     libpq-dev \
     python-pip \
     python-psycopg2 \
     matrix-synapse \
     certbot




