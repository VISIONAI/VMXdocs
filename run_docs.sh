docker run --name docs-nginx -p 80:80 -p 443:443 -v /root/nginx.conf:/etc/nginx/nginx.conf:ro -v /etc/ssl:/etc/ssl_import -v /docs:/docs/ -d nginx
