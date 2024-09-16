# Week 2: ETL pipelines hands-on

## Activities

Run PostgreSQL DB with docker compose
```
docker compose \
	-f source_data/postgres_db/docker_compose_etl.yml \
	--project-name datatech_de_course_week2 \
	up -d
```