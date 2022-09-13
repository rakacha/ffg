# Erpnext custom image builder


The ```Dockerfile``` creates the custom eprnext next image for lifi 

Steps followed to build the image:
1. Get the lifi_custom module from git repo - . It should create a dir named ```lifi_custom``` under the present directory.
2. Run the docker build using the Dockerfile. It uses the frappe/erpnext-worker:v13.27.1 image as base, adds the custom authetication module code from the ```lifi_custom``` directory present in current directory and excutes the intallation of the module on top of the based erpnext image.
``` DOCKER_BUILDKIT=1 docker build -t <image_name> . ```
