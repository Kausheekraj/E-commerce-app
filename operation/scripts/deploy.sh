set -e

ENV="${1}"
docker compose up ${ENV} nginx-export-"$ENV" -d 
