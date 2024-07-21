source "./kubernetes/utils/logger.sh"

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function configure_metrics_server() {
  ENTER
  kubectl apply -f ./kubernetes/extensions/metrics-server/component-v0.7.1.yaml
  EXIT
}

function delete_metrics_server() {
  ENTER
  kubectl delete service metrics-server -n kube-system
  kubectl delete deployment metrics-server -n kube-system
  EXIT
}
