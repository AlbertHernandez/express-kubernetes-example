source "./kubernetes/utils/logger.sh"

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function create_api_gateway() {
  ENTER
  kubectl apply -f ./kubernetes/api-gateway/ingress.yaml -n development
  EXIT
}
