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
    --create-namespace \
    --values ./kubernetes/extensions/monitoring/prometheus-grafana-values.yml
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

function _configure_alloy() {
  ENTER
  helm repo add grafana https://grafana.github.io/helm-charts
  helm repo update
  kubectl create configmap -n monitoring alloy-config "--from-file=config.alloy=./kubernetes/extensions/monitoring/config.alloy"
  helm install alloy grafana/alloy \
    -n monitoring \
    -f ./kubernetes/extensions/monitoring/alloy-values.yaml
  EXIT
}

function _configure_ingress() {
  ENTER
  kubectl apply -f ./kubernetes/extensions/monitoring/ingress.yaml -n monitoring
  EXIT
}

function _configure_open_telemetry_collector() {
  ENTER
  helm repo add open-telemetry-collector https://open-telemetry.github.io/opentelemetry-helm-charts
  helm install opentelemetry-collector open-telemetry/opentelemetry-collector \
    -n monitoring \
    --set image.repository="otel/opentelemetry-collector-k8s" \
    -f ./kubernetes/extensions/monitoring/open-telemetry-collector-values.yaml
  EXIT
}

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function configure_monitoring() {
  ENTER
  _configure_prometheus_and_grafana
  _configure_loki
  _configure_open_telemetry_collector
  _configure_alloy
  _configure_ingress
  add_service_to_hosts_file "grafana.my-company"
  EXIT
}

function delete_monitoring() {
  ENTER
  helm uninstall prometheus -n monitoring
  helm uninstall loki -n monitoring
  helm uninstall alloy -n monitoring
  helm uninstall open-telemetry-collector -n monitoring
  kubectl delete -f ./kubernetes/extensions/monitoring/ingress.yaml -n monitoring
  kubectl delete configmaps --all -n monitoring
  remove_service_from_hosts_file "grafana.my-company"
  EXIT
}
