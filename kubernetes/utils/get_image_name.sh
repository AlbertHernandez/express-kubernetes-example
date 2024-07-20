# Description: This script is used to get the image name for the application.
# Usage: get_image_name <app_name>

function get_image_name() {
  local app=$1
  local commit_hash=$(git rev-parse --short HEAD)
  local image_name="$app:$commit_hash"
  echo "$image_name"
}
