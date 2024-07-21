# Description: This script is used to get the image name for the application.
# Usage: update_version_label_in_kubernetes_deployment <app_name> <env>

source "./logger.sh"
source "./get_image_name.sh"

function update_version_label_in_kubernetes_deployment() {
  ENTER
  local app=$1
  local env=$2
  local image_name=$(get_image_name $app)
  local image_tag=$(echo $image_name | cut -d':' -f2)
  DEBUG "📝 Adding label 'my-company.com/image=$image_tag' to kubernetes deployment $app"
  kubectl label deployment/$app my-company.com/version=$image_tag -n $env --overwrite
  EXIT
}
