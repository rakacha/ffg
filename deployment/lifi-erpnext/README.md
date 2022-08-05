# Erpnext Deployment configuration along with custom authorization app

The ```docker-compose.yml``` contains the entire configuration clubbed together for running the Erpnext container and hosting the reverse-proxies. Details on how this docker-compose file was created can be found here - 
[deployment strategy](https://forceforgood.atlassian.net/wiki/spaces/IF2LII029/pages/3524722824/ErpNext+Deployment+Maintenance+Strategy)


Post checkout, run the following command -

```bash
docker compose -f <path_to_docker_compose_file> --env-file <env_file_name> --project-name <project_name> up -d
```

This command shall spin up the Erpnext application + the custom auth app along with the database installed as mariadb.