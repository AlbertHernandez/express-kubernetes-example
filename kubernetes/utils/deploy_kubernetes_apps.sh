source "../utils/logger.sh"

function build_docker_images() {
  ENTER
  docker build -t express-kubernetes-example -f ../../Dockerfile ../../
  EXIT
}

function start_pods() {
  ENTER
  kubectl apply -f ../pods/express-kubernetes-example.yaml
  EXIT
}

function main() {
  ENTER
  build_docker_images
  start_pods
  EXIT
}

main
