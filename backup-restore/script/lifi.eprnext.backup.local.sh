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
  echo "Processing site:" $site_name
  rm -r ../sites/$site_name

  mkdir ../sites/$site_name

  docker exec $project_name-backend-1 bench --site $site_name backup --with-files

  docker cp $project_name-backend-1:/home/frappe/frappe-bench/sites/$site_name/private/backups/. ../sites/$site_name/
 done


