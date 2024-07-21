source "./kubernetes/utils/logger.sh"
source "./kubernetes/utils/local_hosts_manager.sh"
source "./kubernetes/extensions/metallb/metallb_manager.sh"
source "./kubernetes/extensions/ingress-nginx/ingress-nginx_manager.sh"
source "./kubernetes/extensions/metrics-server/metrics_server_manager.sh"

function delete_development_resources() {
  ENTER
  kubectl delete all --all -n development
  kubectl delete ingress --all -n development
  kubectl delete configmaps --all -n development
  EXIT
}

function delete_all_resources() {
  ENTER
  delete_development_resources
  delete_ingress_nginx
  delete_metrics_server
  delete_metallb_resources
  EXIT
}

function main() {
  ENTER
  delete_all_resources
#  remove_company_entry_from_hosts_file
  EXIT
}

main
