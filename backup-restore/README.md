# Erpnext Backup and Google Drive Push Job

## Backup and push to Google Drive

Step 1: Go to the /backup-restore/scripts dir

Step 2: Run the backup script to take the back up and push to google drive. The Google Drive is configured for [info@learninginitiativesofindia.com](info@learninginitiativesofindia.com). The script supports multiple site backups.

```bash
sh lifi.eprnext.backup.gdrive.sh -s <site2>,<site1> -p <project_name>
Example:
sh lifi.eprnext.backup.gdrive.sh -s sit.lifi,uat.lifi -p lifi-central
```
Step 3: Finally add the docker compose job in crontab to run in a specific scehdule. For ex - 

```bash
0 2 * * * sh lifi.eprnext.backup.gdrive.sh -s sit.lifi,uat.lifi -p lifi-central > /dev/null
```

Optional-1: the ```lifi.eprnext.backup.local.sh``` script can be run for adhoc backups and copying the backup folder from the container to local host dir. The command to run the script -

```bash
 sh lifi.eprnext.backup.local.sh -p <docker_compose_project_name> -s <site1_name>, <site2_name>

Example:
sh lifi.eprnext.backup.local.sh -s sit.lifi,uat.lifi -p lifi-central
```

Optional-2: the ```docker-compose-backup-template.yml``` config can be run for adhoc push to google drive. The command to run the script -

```bash
docker compose --env-file <env_file_name> -f <docker-compose_file_name> up
 
Example:
docker compose --env-file backup-config.env -f docker-compose-backup-template.yml up
```

## Download from Google Drive and restore the site


Step 1: Go to the /backup-restore/scripts dir

Step 2: Run the restore script to download the back ups from google drive. The Google Drive is configured for [info@learninginitiativesofindia.com](info@learninginitiativesofindia.com). And then run the bench restore command

```bash
sh lifi.eprnext.restore.gdrive.sh -p <project_name> -s <site_name> -l <gdrive_backup_folder_location> -r <to_be_restored_file_prefix> -d <db_root_password>

 
Example:
sh lifi.eprnext.restore.gdrive.sh -p lifi-erpnext-runner -s lifi.erpnext -l lifi.erpnext.backup -r 20220625_142927-lifi_erpnext -d password
```

