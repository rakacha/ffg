# Erpnext Backup and Google Drive Push Job



Step 1: Uses the existing Erpnext backend service to execute the backup job using. This will be configured in crontab - 

```bash
0 2 * * * docker compose --project-name lifi-erpnext-runner exec backend bench --site lifi.erpnext backup --with-files
```

Step 2: The ```docker-compose-backup.yml``` contains the entire configuration. It uses the ```lifi-backup-app:1.0.0``` to push the backup files in Google Drive of info@learninginitiativesofindia.com account.

The Dockerfile is used to build the lifi-backup-app:1.0.0 container. This spins up python container and pushes the changes to Google Drive. This can be done for multiple sites where multiple container is executed for that.

Step 3: Finally add the docker compose job in crontab to run in a specific scehdule. For ex - 

```bash
0 2 * * * docker compose -f /home/azureuser/LIFI/backups/docker-compose-backup.yml up -d > /dev/null
```

Optional-1: the ```lifi.eprnext.backup.local.sh``` script can be run for adhoc backups and copying the backup folder from the container to local host dir. The command to run the script -

```bash
 sh lifi.eprnext.backup.sh -p <docker_compose_project_name> -s <site1_name>, <site2_name>

 sh /home/azureuser/LIFI/backups/lifi.eprnext.backup.sh lifi-erpnext-runner uat.lifi.erpnext
```

Optional-2: the ```docker-compose-backup-template.yml``` script can be run for adhoc backups and copying the backup folder from the container to local host dir. The command to run the script -

```bash
 sh lifi.eprnext.backup.sh -p <docker_compose_project_name> -s <site1_name>, <site2_name>

 sh /home/azureuser/LIFI/backups/lifi.eprnext.backup.sh lifi-erpnext-runner uat.lifi.erpnext
```
