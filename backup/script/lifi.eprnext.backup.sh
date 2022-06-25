#!/bin/sh
echo Running the backup job

rm -r /home/azureuser/LIFI/backups/sites/$2

mkdir /home/azureuser/LIFI/backups/sites/$2

docker exec lifi-erpnext-runner-backend-1 bench --site $2 backup --with-files

docker cp lifi-erpnext-runner-backend-1:/home/frappe/frappe-bench/sites/$2/private/backups/. /home/azureuser/LIFI/backups/sites/$2/


