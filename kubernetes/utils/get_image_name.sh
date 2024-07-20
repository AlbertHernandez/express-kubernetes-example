# Description: This script is used to get the image name with the commit hash.
# Usage: get_image_name <image_name>

function get_image_name() {
  local commit_hash=$(git rev-parse --short HEAD)
  local image_name="$1:$commit_hash"
  echo "$image_name"
}
