FROM nginx:latest
COPY ./server-configuration/default.conf /default.conf
CMD ["/bin/sh" , "-c" , "envsubst '${LISTEN_PORT},${SITE_NAME},${HOST_NAME}' < ./default.conf > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"]
