#!/bin/bash

source "./kubernetes/utils/logger.sh"
source "./kubernetes/utils/create_namespaces.sh"
source "./kubernetes/extensions/ingress-nginx/ingress-nginx_manager.sh"
source "./kubernetes/extensions/metallb/metallb_manager.sh"
source "./kubernetes/extensions/metrics-server/metrics_server_manager.sh"
source "./kubernetes/apps/express-kubernetes-example/create_resources.sh"
source "./kubernetes/api-gateway/create_api_gateway.sh"
source "./kubernetes/utils/local_hosts_manager.sh"

function configure_sops() {
  ENTER
  INFO "🔐 Configuring sops..."
  gpg --import sops.asc
  export SOPS_PGP_FP="D7229043384BCC60326C6FB9D8720D957C3D3074"
  EXIT
}

function main() {
  ENTER
  configure_sops
  create_namespaces
  create_ingress_nginx
  create_metallb_resources
  configure_metrics_server
  create_express_kubernetes_example_resources
  create_api_gateway
  add_company_entry_to_hosts_file
  EXIT
}

main
