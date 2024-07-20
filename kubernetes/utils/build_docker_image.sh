# Description: This script is used to get the image name for the application.
# Usage: build_docker_image <app_name> <env>

source "./logger.sh"
source "./get_image_name.sh"

function build_docker_image() {
  ENTER
  local app=$1
  local env=$2
  local image_name=$(get_image_name $app)
  INFO "🐳 Building docker image $image_name"
  docker build -t $image_name -t $app:$env -f ../../Dockerfile ../../
  EXIT
}
