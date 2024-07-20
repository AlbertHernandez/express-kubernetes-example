source "../utils/logger.sh"

function build_docker_images() {
  ENTER
  docker build -t express-kubernetes-example -f ../../Dockerfile ../../
  EXIT
}

function start_deployments() {
  ENTER
  kubectl apply -f ../deployments/express-kubernetes-example.yaml
  EXIT
}

function start_services() {
  ENTER
  kubectl apply -f ../services/express-kubernetes-example.yaml
  EXIT
}

function configure_hpas() {
  ENTER
  kubectl apply -f ../hpas/metrics-server/component-v0.7.1.yaml
  kubectl apply -f ../hpas/express-kubernetes-example.yaml
  EXIT
}

function main() {
  ENTER
  build_docker_images
  start_deployments
  start_services
  configure_hpas
  EXIT
}

main
