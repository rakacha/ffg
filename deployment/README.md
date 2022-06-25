# Erpnext Deployment configuration

The ```docker-compose.yml``` contains the entire configuration clubbed together for running the Erpnext container and hosting the reverse-proxies. Details on how this docker-compose file was created can be found here - 
https://forceforgood.atlassian.net/wiki/spaces/IF2LII029/pages/3524722824/ErpNext+Deployment+Maintenance+Strategy


This configuration supports port based multi-tenancy where 2 Erpnext sites are configured and served at 8081 (UAT) and 80 (Prod) ports. 

Post checkout, please run the following command -

```bash
docker compose -f <path_to_docker_compose_file> --project-name <project_name> up -d
```
