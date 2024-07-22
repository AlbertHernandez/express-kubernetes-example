source "./kubernetes/utils/logger.sh"
source "./kubernetes/utils/update_version_label_in_kubernetes_deployment.sh"
source "./kubernetes/utils/build_docker_image.sh"

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function create_express_kubernetes_example_resources() {
  ENTER
  build_docker_image "express-kubernetes-example" "development"
  kubectl apply -f ./kubernetes/apps/express-kubernetes-example/deployment.yaml -n development
  update_version_label_in_kubernetes_deployment "express-kubernetes-example" "development"
  kubectl apply -f ./kubernetes/apps/express-kubernetes-example/service.yaml -n development
  kubectl apply -f ./kubernetes/apps/express-kubernetes-example/hpa.yaml -n development
  EXIT
}
