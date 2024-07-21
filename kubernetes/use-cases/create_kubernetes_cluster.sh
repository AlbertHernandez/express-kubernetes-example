#!/bin/bash

source "./kubernetes/utils/logger.sh"
source "./kubernetes/utils/create_namespaces.sh"
source "./kubernetes/extensions/ingress-nginx/ingress-nginx_manager.sh"
source "./kubernetes/extensions/metallb/metallb_manager.sh"
source "./kubernetes/extensions/metrics-server/metrics_server_manager.sh"
source "./kubernetes/apps/express-kubernetes-example/create_resources.sh"
source "./kubernetes/utils/local_hosts_manager.sh"

function main() {
  ENTER
  create_namespaces
  create_ingress_nginx
  create_metallb_resources
  configure_metrics_server
  create_express_kubernetes_example_resources
#  add_company_entry_to_hosts_file
  EXIT
}

main
