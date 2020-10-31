#!/bin/bash

# Settings

CLOUD_DOMAIN="cloud_os.test"
MANAGER_NODE="docker0"


# Script

CLOUD_KEY=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 128`
CLOUD_MYSQL_PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16`
PROD_MYSQL_PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16`

mkdir -p keys

rm -f keys/auth_private.key
rm -f keys/auth_public.key

openssl genrsa -out keys/auth_private.key 2048
openssl rsa -in keys/auth_private.key -outform PEM -pubout -out keys/auth_public.key

cat files/env.cloud_os.example > keys/env.cloud_os.conf
cat files/env.prod.example > keys/env.prod.conf

sed -i "s|MYSQL_ROOT_PASSWORD=.*|MYSQL_ROOT_PASSWORD=${CLOUD_MYSQL_PASSWORD}|g" keys/env.cloud_os.conf;
sed -i "s|MYSQL_PASSWORD=.*|MYSQL_PASSWORD=${CLOUD_MYSQL_PASSWORD}|g" keys/env.cloud_os.conf;
sed -i "s|CLOUD_DOMAIN=.*|CLOUD_DOMAIN=${CLOUD_DOMAIN}|g" keys/env.cloud_os.conf;
sed -i "s|CLOUD_KEY=.*|CLOUD_KEY=${CLOUD_KEY}|g" keys/env.cloud_os.conf;

sed -i "s|MYSQL_ROOT_PASSWORD=.*|MYSQL_ROOT_PASSWORD=${CLOUD_MYSQL_PASSWORD}|g" keys/env.prod.conf;
sed -i "s|MYSQL_PASSWORD=.*|MYSQL_PASSWORD=${CLOUD_MYSQL_PASSWORD}|g" keys/env.prod.conf;
sed -i "s|CLOUD_DOMAIN=.*|CLOUD_DOMAIN=${CLOUD_DOMAIN}|g" keys/env.prod.conf;
sed -i "s|CLOUD_KEY=.*|CLOUD_KEY=${CLOUD_KEY}|g" keys/env.prod.conf;


if [ ! -d save ]; then
  mkdir -p save
  cp keys/auth_private.key save/auth_private.key
  cp keys/auth_public.key save/auth_public.key
  cp keys/env.cloud_os.conf save/env.cloud_os.conf
  cp keys/env.prod.conf save/env.prod.conf
fi