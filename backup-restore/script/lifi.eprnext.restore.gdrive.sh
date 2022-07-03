#!/bin/bash

if [ "$1" = "-h" ] 
 then
  echo "Site restore command usage:"
  echo "-s <site_name>"
  echo "-p <project_name>"
  echo "-l <restore_dir_location_in google_drive>"
  echo "-f <file_name_prefix to download from google drive dir>"
  echo "-r <root password of Mysql DB>"
  echo "-d <optinal parameter: pass the application schema password. If not provided a random password will be generated.>"
  exit 0
fi

echo Running the restore job

while getopts s:p:l:f:r:d: flag
do
    case "${flag}" in
        s) site_name=${OPTARG};;
        p) project_name=${OPTARG};;
		l) file_loc=${OPTARG};;
		f) file_name_prefix=${OPTARG};;
		r) db_pass=${OPTARG};;
		d) lifi_db_pass=${OPTARG};;
     esac
done

echo "Site Name:"  $site_name
echo "Project Name" $project_name
echo "File Location in GDrive" $file_loc
echo "File Name Prefix" $file_name_prefix



if [ -z "$site_name" ]
 then
  echo Site Names cannot be empty. for ex, -s site
  exit
fi

if [ -z "$project_name" ]
 then
  echo Project Name cannot be empty. For ex, -p project
  exit
fi

if [ -z "$file_loc" ]
 then
  echo Gdrive file location cannot be empty. For ex, -l location
  exit
fi

if [ -z "$file_name_prefix" ]
 then
  echo Restoring File Name Prefix cannot be empty. For ex, -f prefix
  exit
fi

if [ -z "$db_pass" ]
 then
  echo DB root password cannot be empty. For ex, -r pass
  exit
fi

echo "Restore process started with backups from Gdrive for site:" $site_name 
echo "Step 1: Downloading backups from Gdrive for site:" $site_name "from location: " $file_loc

docker run -i -v gdrive-job-vol:/app --name gdrive-sync-job1 -e SYNC_MODE=DOWNLOAD -e RESTORE_FILE_PREFIX=$file_name_prefix -e RESTORE_PATH=$file_loc --network frappe_docker_default rakacha/lifi-grdrive-sync:1.0.0

echo "Step 2: Copying files from gdrive sync job container: gdrive-sync-job1"

rm -r temp_drive_bcup
mkdir temp_drive_bcup

docker cp gdrive-sync-job1:/app/temp/. temp_drive_bcup

if [ -z "$(ls -A temp_drive_bcup)" ]
 then
    echo "There is no backup file with the given file name. Please check if you have entered right file name prefix."
	echo "Step 3: Removing gdrive sync job container : "
	docker container rm gdrive-sync-job1
	exit
 else
    echo "Downloaded backups successfully."
fi

echo "Step 3: Removing gdrive sync job container : "
docker container rm gdrive-sync-job1

echo "Step 4: Executing the create new site: " $site_name

if [ -z "$lifi_db_pass" ]
 then
  echo "DB password not provided  for application schema, creating the site with random password."
  docker exec -i $project_name-backend-1 bash bench new-site $site_name --mariadb-root-password $db_pass --db-name $site_name.db --admin-password admin --install-app erpnext --force
 else
  echo "DB password provided  for application schema, creating the site with provided password."
  docker exec -i $project_name-backend-1 bash bench new-site $site_name --mariadb-root-password $db_pass --db-name $site_name.db --db-password $lifi_db_pass --admin-password admin --install-app erpnext --force
fi

echo "Step 5: Enabling scheduler for site: " $site_name
docker compose --project-name $project_name exec backend bench --site $site_name enable-scheduler

echo "Step 6: Copying sql dump and files to erpnext worker container"
container_backup_path=/home/frappe/frappe-bench/sites/$site_name
docker cp ./temp_drive_bcup/. $project_name-backend-1:$container_backup_path/private/backups


echo "Step 7: Executing the bench restore command for site: " $site_name
docker exec -i $project_name-backend-1 bash bench --site $site_name restore --db-root-password $db_pass --with-public-files $container_backup_path/private/backups/$file_name_prefix-files.tar --with-private-files  $container_backup_path/private/backups/$file_name_prefix-private-files.tar $container_backup_path/private/backups/$file_name_prefix-database.sql.gz

if [ -z "$lifi_db_pass" ]
 then
	echo "Step 8: Copying site config file: " $file_name_prefix-site_config_backup.json " to erpnext site: " $site_name
	docker cp ./temp_drive_bcup/$file_name_prefix-site_config_backup.json $project_name-backend-1:$container_backup_path/site_config.json
fi