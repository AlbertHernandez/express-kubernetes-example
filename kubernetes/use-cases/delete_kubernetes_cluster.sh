source "./kubernetes/utils/logger.sh"
source "./kubernetes/utils/local_hosts_manager.sh"
source "./kubernetes/extensions/metallb/metallb_manager.sh"
source "./kubernetes/extensions/ingress-nginx/ingress-nginx_manager.sh"
source "./kubernetes/extensions/metrics-server/metrics_server_manager.sh"

function delete_all_ingress_in_development() {
  ENTER

  local namespace="development"

  INFO "📝 Deleting all Ingress resources in the '$namespace' namespace."

  ingress_list=$(kubectl get ingress -n "$namespace" -o name)

  if [ -z "$ingress_list" ]; then
    INFO "ℹ️ No Ingress resources found in the '$namespace' namespace."
  else
    for ingress in $ingress_list; do
      INFO "📝 Deleting $ingress in the '$namespace' namespace."
      kubectl delete "$ingress" -n "$namespace"

      if [ $? -eq 0 ]; then
        INFO "✅ Successfully deleted $ingress."
      else
        ERROR "❌ Error deleting $ingress."
      fi
    done
  fi

  EXIT
}

function delete_development_resources() {
  ENTER
  kubectl delete all --all -n development
  delete_all_ingress_in_development
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
