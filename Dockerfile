FROM nginx:1-alpine

ENV REDIRECT_CODE 301
ENV REDIRECT_SUBDOMAIN www
ADD default.template /etc/nginx/conf.d/default.template

CMD  ["/bin/sh", "-c", "envsubst \\$REDIRECT_CODE,\\$REDIRECT_SUBDOMAIN < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"]
