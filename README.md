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

## Easy Installation Steps

1. Clone the repo
2. Go inside the deployment dir:
  ``` bash 
 cd ffg/deployment 
```

3. run the following to spin up the erpnext instance

```bash
 docker compose --project-name lifi-erpnext-runner --env-file prod.env up -d
```
4. Select the date time of the back up from Google Drive (use LIFI Admin Account) that you want to restore, for ex - "20220726_092703-lifi_erpnext". Also note the db password from the "***_site_config.json" file from Google Drive copy that you want to restore. Following which run the restore script -

```bash
 sh lifi.eprnext.restore.gdrive.sh -s lifi.erpnext -p lifi-erpnext-runner -l lifi.erpnext.backup -f 20220726_092703-lifi_erpnext -r <mysql_root_password_selected_during_initial_app_setup>-d <password_of_app_schema_that_you_want_to_restore_found_in_the_backed_up_site_config_json>
```
A help of the shell script is available - 
```bash
azureuser@LIFI1:~/LIFI/devops/ffg/backup-restore/script$ sh lifi.eprnext.restore.gdrive.sh -h
Site restore command usage:
-s <site_name>
-p <project_name>
-l <restore_dir_location_in google_drive>
-f <file_name_prefix to download from google drive dir>
-r <root password of Mysql DB>
-d <optinal parameter: pass the application schema password. If not provided a random password will be generated.>

```
Note for the the first time i..e when deploying in a VM for the first time, the google drive auth fileis not there. Hence you need to manually copy the file in the container space -
```bash
docker cp <path_to_gdrive_service_account_creds_json> gdrive-sync-job-sync-site-1:app/
```
### That's it!!

