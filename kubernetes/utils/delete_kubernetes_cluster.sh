source "./logger.sh"
source "./local_hosts_manager.sh"

function delete_all_resources() {
  ENTER
  kubectl delete all --all --all-namespaces
  EXIT
}

function main() {
  ENTER
  delete_all_resources
  remove_company_entry_from_hosts_file
  EXIT
}

main
