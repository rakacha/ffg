#!/bin/bash

echo Running the backup job

while getopts s:p: flag
do
    case "${flag}" in
        s) site_names=${OPTARG};;
        p) project_name=${OPTARG};;
     esac
done

echo "Site Names:"  $site_names
echo "Project Name" $project_name


if [ -z "$site_names" ]
 then
  echo Site Names cannot be empty. Please provide comma separated site names. for ex, -s site1,site2
  exit
fi

if [ -z "$project_name" ]
 then
  echo Project Name cannot be empty. For ex, -p project1
  exit
fi

site_arr=$(echo $site_names | tr "," "\n")

for site_name in $site_arr

 do
  echo "Backup process started for site:" $site_name
  echo "******************************************************************************************"
  echo "Step 1: Running backup command for site: " $site_name
  echo "******************************************************************************************"
  docker exec $project_name-backend-1 bench --site $site_name backup --with-files --compress
  
  echo "******************************************************************************************"
  echo "Step 2: Backup run successfully, now processing to upload in Google Drive"
  echo "******************************************************************************************"
  
  export GDRIVE_SYNC_MODE=UPLOAD
  export BACKUP_SITE_NAME=$site_name
  export BACKUP_GDRIVE_PATH=$site_name.backup
  export WORKING_DIR=/home/azureuser/LIFI/devops
  
  envsubst '${GDRIVE_SYNC_MODE}, ${BACKUP_SITE_NAME},${BACKUP_GDRIVE_PATH}' < ${WORKING_DIR}/ffg/backup-restore/docker-compose-backup-template.yml > ${WORKING_DIR}/ffg/backup-restore/docker-compose-backup.yml
  
  docker compose --project-name lifi_backup_job -f ${WORKING_DIR}/ffg/backup-restore/docker-compose-backup.yml up
  
  unset BACKUP_SITE_NAME
  unset BACKUP_GDRIVE_PATH
  unset SYNC_MODE
  
  echo "Backup prcoess completed for site: " $site_name
 done


