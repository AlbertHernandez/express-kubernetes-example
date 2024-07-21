source "./kubernetes/utils/logger.sh"
source "./kubernetes/utils/local_hosts_manager.sh"
source "./kubernetes/extensions/metallb/metallb_manager.sh"

function delete_all_resources() {
  ENTER
  kubectl delete all --all --all-namespaces
  delete_metallb_resources
  EXIT
}

function main() {
  ENTER
  delete_all_resources
  remove_company_entry_from_hosts_file
  EXIT
}

main
