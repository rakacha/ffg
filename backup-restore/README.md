# Erpnext Backup and Google Drive Push Job



Step 1: Uses the existing Erpnext backend service to execute the backup job using. The script ```lifi.eprnext.backup.gdrive.sh``` is written to take to run the backup and push the backups in Google drive.

```bash
sh lifi.eprnext.backup.gdrive.sh -s <site2>,<site1> -p <project_name>
Example:
sh lifi.eprnext.backup.gdrive.sh -s sit.lifi,uat.lifi -p lifi-central
```
The ```docker-compose-backup-template.yml``` contains the entire configuration. It uses the ```lifi-backup-app``` to push the backup files in Google Drive of info@learninginitiativesofindia.com account.

The Dockerfile is used to build the ```lifi-backup-app``` container. This spins up python container and pushes the changes to Google Drive. This can be done for multiple sites where multiple container is executed for that.

Step 2: Finally add the docker compose job in crontab to run in a specific scehdule. For ex - 

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
