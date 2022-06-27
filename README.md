# Erpnext Maintenance repo



Step 1: Clone the repo - 

Step 2: Set the working dir environment variable 

```bash
export WORKING_DIR=<path_to_clone_directory>
```

It has 3 child directories 

1. backup-restore - takes care of the erpnext site backup restore process
2. deployment - takes care of the deployment prcoess and installation of a new erpnext site
3. rev-proxy-server - reverse proxy server (nginx) to point a request dynamically to a site. This contains a nginx config file and Dockerfile to create the image.