source "./logger.sh"
source "./local_hosts_manager.sh"

function delete_pools() {
  ENTER
  if kubectl get IPAddressPool metallb-pool -n metallb-system > /dev/null 2>&1; then
    INFO "📝 Deleting IPAddressPool 'metallb-pool' in namespace 'metallb-system'."
    kubectl delete IPAddressPool metallb-pool -n metallb-system
  else
    INFO "ℹ️ IPAddressPool 'metallb-pool' does not exist in namespace 'metallb-system'."
  fi
  EXIT
}

function delete_l2_advertisement() {
  if kubectl get L2Advertisement homelab-l2 -n metallb-system > /dev/null 2>&1; then
    INFO "📝 Deleting L2Advertisement 'homelab-l2' in namespace 'metallb-system'."
    kubectl delete L2Advertisement homelab-l2 -n metallb-system
  else
    INFO "ℹ️ L2Advertisement 'homelab-l2' does not exist in namespace 'metallb-system'."
  fi
}

function delete_all_resources() {
  ENTER
  kubectl delete all --all --all-namespaces
  delete_pools
  delete_l2_advertisement
  EXIT
}

function main() {
  ENTER
  delete_all_resources
  remove_company_entry_from_hosts_file
  EXIT
}

main
