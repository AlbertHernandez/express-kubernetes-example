source "./kubernetes/utils/logger.sh"
source "./kubernetes/utils/local_hosts_manager.sh"

# ====================================================== #
#                  Private Methods                       #
# ====================================================== #

function _configure_prometheus_and_grafana() {
  ENTER
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
  helm install prometheus \
    -n monitoring prometheus-community/kube-prometheus-stack \
    --create-namespace
  EXIT
}

function _configure_loki() {
  ENTER
  helm repo add grafana https://grafana.github.io/helm-charts
  helm repo update
  helm install -n monitoring \
    --values ./kubernetes/extensions/monitoring/loki-values.yml loki grafana/loki
  EXIT
}

function _configure_ingress() {
  ENTER
  kubectl apply -f ./kubernetes/extensions/monitoring/ingress.yaml -n monitoring
  EXIT
}

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function configure_monitoring() {
  ENTER
  _configure_prometheus_and_grafana
  _configure_loki
  _configure_ingress
  add_service_to_hosts_file "grafana.my-company"
  EXIT
}

function delete_monitoring() {
  ENTER
  helm uninstall prometheus -n monitoring
  helm uninstall loki -n monitoring
  kubectl delete -f ./kubernetes/extensions/monitoring/ingress.yaml -n monitoring
  remove_service_from_hosts_file "grafana.my-company"
  EXIT
}
