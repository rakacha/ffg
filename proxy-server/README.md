# Reverse Proxy For NGINX

The server-```configuration/default.conf``` template file contains 2 placeholder variables viz. ```${LISTEN_PORT}``` and ```${SITE_NAME}```. 

The Dockerfile replaces the above 2 placeholder with environment variables passed during container runtime. This was the same image can be used to bring up containers listening to multiple ports pointing different Erpnext sites.

The image is already build and pushed to docker hub. That is referenced from deployment/docker-compose.yml