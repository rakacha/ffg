# Reverse Proxy For NGINX

The server-```configuration/default.conf``` template file contains 3 placeholder variables viz. ```${LISTEN_PORT}```,  ```${SITE_NAME}``` and  ```${HOST_NAME}```. 
The site name and host name variables are kept the same for now.

The Dockerfile replaces the above 3 placeholder with environment variables passed during container runtime. This was the same image can be used to bring up containers listening to multiple ports pointing different Erpnext sites.

The image is already build and pushed to docker hub. That is referenced from deployment/docker-compose.yml