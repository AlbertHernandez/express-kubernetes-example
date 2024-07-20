source "../utils/logger.sh"

function configure_hpa_tools() {
  ENTER
  kubectl apply -f ./metrics-server/component-v0.7.1.yaml
  EXIT
}

function create_express_kubernetes_example_resources() {
  ENTER
  docker build -t express-kubernetes-example -f ../../Dockerfile ../../
  kubectl apply -f ../apps/express-kubernetes-example/deployment.yaml
  kubectl apply -f ../apps/express-kubernetes-example/service.yaml
  kubectl apply -f ../apps/express-kubernetes-example/hpa.yaml
  EXIT
}

function main() {
  ENTER
  configure_hpa_tools
  create_express_kubernetes_example_resources
  EXIT
}

main
