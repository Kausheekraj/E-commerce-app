set -e

ENV="${1}"
docker compose up cadvisor ${ENV} nginx-export-"$ENV" -d 
