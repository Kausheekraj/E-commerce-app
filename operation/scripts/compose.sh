#!/usr/bin/env bash
# Absolute path to this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)" 

# Project root = one level above /operation
OPERATION_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Paths inside operation
DOCKER_DIR="$OPERATION_ROOT/Docker/"
SCRIPTS_DIR="$OPERATION_ROOT/scripts/"
cd "${DOCKER_DIR}"
ENV=""
build=false
push=false
deploy=false
stop=false
remove_container=false
remove_image=false
remove_all=false

usage () {
  echo "[Usage]: $0 (--prod|-P||--dev|-D) [options]"  
  echo "Options:"
  echo "  -b       Build image"
  echo "  -p       Push Image to repo"
  echo "  -d       Deploy container"
  echo "  -s       Stop container"
  echo "  --rme    Remove container"
  echo "  --rmi    Remove image"
  echo "  --rm-all Remove all"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prod|-P) ENV="prod" ;;
    --dev|-D)  ENV="dev" ;;
    -b) build=true ;;
    -p) push=true ;;
    -d) deploy=true ;;
    -s) stop=true ;;
    --rmi) remove_image=true ;;
    --rme) remove_container=true ;;
    --rm-all) remove_all=true ;;
    -h|--help) usage ;;
    *) echo " Unknown option: $1"; usage ;;
  esac
  shift
done

# Validate env
if [[ -z "$ENV" ]]; then
  echo " Environment not set"
  echo "Use '--prod' or '--dev' to declare the environment"
  exit 1
fi

echo ">>>>> Running changes in Environment: $ENV"

# Execution flow
$build            && bash "${SCRIPTS_DIR}"build.sh "$ENV"
$push             && bash "${SCRIPTS_DIR}"build.sh "$ENV" -p
$deploy           && bash "${SCRIPTS_DIR}"deploy.sh "$ENV"
$stop             && bash "${SCRIPTS_DIR}"options.sh "$ENV" -s
$remove_container && bash "${SCRIPTS_DIR}"options.sh "$ENV" -c
$remove_image     &&  bash "${SCRIPTS_DIR}"options.sh "$ENV" -i
$remove_all       &&  bash "${SCRIPTS_DIR}"options.sh "$ENV" -a

exit 0
