source "./kubernetes/utils/logger.sh"

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function delete_express_kubernetes_example_resources() {
  ENTER
  kubectl delete ingress ingress-express-kubernetes-example -n development
  EXIT
}
