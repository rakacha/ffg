#!/bin/bash

echo Running the restore job

while getopts s:p:l:r:d: flag
do
    case "${flag}" in
        s) site_name=${OPTARG};;
        p) project_name=${OPTARG};;
		l) file_loc=${OPTARG};;
		r) file_name_prefix=${OPTARG};;
		d) db_pass=${OPTARG};;
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
  echo Restoring File Name Prefix cannot be empty. For ex, -r prefix
  exit
fi

if [ -z "$db_pass" ]
 then
  echo DB root password cannot be empty. For ex, -d pass
  exit
fi

echo "Restoring site:" $site_name
docker run --name lifi-restore-job1  -e RESTORE_FILE_PREFIX=$file_name_prefix -e RESTORE_PATH=$file_loc --network frappe_docker_default rakacha/lifi-restore-job:1.0.0

rm -r temp_drive_bcup
mkdir temp_drive_bcup

echo "Copying files from restore container"
docker cp lifi-restore-job1:/app/temp_drive_bcup/. temp_drive_bcup

echo "Removing container"
docker container rm lifi-restore-job1

echo "Copying to erpnext worker container"
container_backup_path=/home/frappe/frappe-bench/sites/$site_name/private/backups
docker cp ./temp_drive_bcup/. $project_name-backend-1:$container_backup_path

echo "Executing the bench restore command"
docker exec $project_name-backend-1 bash bench --site $site_name restore --db-root-password $db_pass --with-public-files $container_backup_path/$file_name_prefix-files.tar --with-private-files  $container_backup_path/$file_name_prefix-private-files.tar $container_backup_path/$file_name_prefix-database.sql.gz