source "../utils/logger.sh"

function delete_all_resources() {
  ENTER
  kubectl delete all --all --all-namespaces
  EXIT
}

function main() {
  ENTER
  delete_all_resources
  EXIT
}

main
