set -e
ENV="${1}"
image="kausheekraj/ecommerce-nginx"
shift 
while getopts "scia" opts; do
  case "${opts}" in
    s) docker compose stop  "${ENV}" ;;
    i) docker  rmi "${image}:${ENV}" ;;
    c) docker compose rm -f ${ENV} ;;
    a) docker compose rm -f "$ENV" ;  docker  rmi "${image}":${ENV}  ;;
  esac
done


