# Erpnext custom image builder


The ```Dockerfile``` creates the custom eprnext next image for lifi 

Steps followed to build the image:
1. Get the lifi_custom module from git repo - 
2. Run the docker build using the Dockerfile. It uses the frappe/erpnext-worker:v13.27.1 image as base, adds the custom authetication module code from the ```lifi_custom``` and excutes the intallation of the module on top of the based erpnext image.
