source "./logger.sh"
source "./build_docker_image.sh"
source "./update_version_label_in_kubernetes_deployment.sh"

function create_namespaces() {
  ENTER
  kubectl create namespace development
  EXIT
}

function configure_hpa_tools() {
  ENTER
  kubectl apply -f ./metrics-server/component-v0.7.1.yaml
  EXIT
}

function create_express_kubernetes_example_resources() {
  ENTER
  build_docker_image "express-kubernetes-example" "development"
  kubectl apply -f ../apps/express-kubernetes-example/deployment.yaml -n development
  update_version_label_in_kubernetes_deployment "express-kubernetes-example" "development"
  kubectl apply -f ../apps/express-kubernetes-example/service.yaml -n development
  kubectl apply -f ../apps/express-kubernetes-example/hpa.yaml -n development
  EXIT
}

function main() {
  ENTER
  create_namespaces
  configure_hpa_tools
  create_express_kubernetes_example_resources
  EXIT
}

main
