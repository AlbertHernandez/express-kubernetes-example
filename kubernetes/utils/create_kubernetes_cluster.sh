source "../utils/logger.sh"

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
  docker build -t express-kubernetes-example:development -f ../../Dockerfile ../../
  kubectl apply -f ../apps/express-kubernetes-example/deployment.yaml -n development
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
