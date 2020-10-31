#!/bin/bash

# Settings

CLOUD_DOMAIN="cloud_os.local"
MANAGER_NODE="docker0"


# Script

CLOUD_KEY=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 128`
CLOUD_MYSQL_PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16`
PROD_MYSQL_PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16`

rm -f files/auth_private.key
rm -f files/auth_public.key

openssl genrsa -out files/auth_private.key 2048
openssl rsa -in files/auth_private.key -outform PEM -pubout -out files/auth_public.key

cat files/env.cloud_os.example > files/env.cloud_os.conf
cat files/env.prod.example > files/env.prod.conf

sed -i "s|MYSQL_ROOT_PASSWORD=.*|MYSQL_ROOT_PASSWORD=${CLOUD_MYSQL_PASSWORD}|g" files/env.cloud_os.conf;
sed -i "s|MYSQL_PASSWORD=.*|MYSQL_PASSWORD=${CLOUD_MYSQL_PASSWORD}|g" files/env.cloud_os.conf;
sed -i "s|CLOUD_DOMAIN=.*|CLOUD_DOMAIN=${CLOUD_DOMAIN}|g" files/env.cloud_os.conf;
sed -i "s|CLOUD_KEY=.*|CLOUD_KEY=${CLOUD_KEY}|g" files/env.cloud_os.conf;

sed -i "s|MYSQL_ROOT_PASSWORD=.*|MYSQL_ROOT_PASSWORD=${CLOUD_MYSQL_PASSWORD}|g" files/env.prod.conf;
sed -i "s|MYSQL_PASSWORD=.*|MYSQL_PASSWORD=${CLOUD_MYSQL_PASSWORD}|g" files/env.prod.conf;
sed -i "s|CLOUD_DOMAIN=.*|CLOUD_DOMAIN=${CLOUD_DOMAIN}|g" files/env.prod.conf;
sed -i "s|CLOUD_KEY=.*|CLOUD_KEY=${CLOUD_KEY}|g" files/env.prod.conf;


if [ ! -d test ]; then
  mkdir -p test
  cp files/auth_private.key test/auth_private.key
  cp files/auth_public.key test/auth_public.key
  cp files/env.cloud_os.conf test/env.cloud_os.conf
  cp files/env.prod.conf test/env.prod.conf
fi