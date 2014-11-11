#!/bin/sh
# Simple script to stop the docs container and restart it

cd `dirname $0`
docker stop docs-nginx
docker rm docs-nginx
docker run --name docs-nginx -p 80:80 -p 443:443 -v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro -v /etc/ssl:/etc/ssl_import -v /docs:/docs/ -d nginx
