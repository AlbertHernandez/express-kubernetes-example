source "./kubernetes/utils/logger.sh"

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function configure_metrics_server() {
  ENTER
  kubectl apply -f ./kubernetes/extensions/metrics-server/component-v0.7.1.yaml
  EXIT
}
