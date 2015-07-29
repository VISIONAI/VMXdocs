#!/bin/sh
# Simple script to stop the docs container and restart it

cd `dirname $0`
docker stop docs-nginx
docker rm docs-nginx

#Start an nginx server which serves the /docs directory over HTTPS using a virtual_host and nginx-ssl-proxy for docker containers
docker run --name docs-nginx -p 127.0.0.1:5000:80 -e VIRTUAL_HOST=docs.vision.ai -v /docs:/usr/share/nginx/html:ro -d nginx
