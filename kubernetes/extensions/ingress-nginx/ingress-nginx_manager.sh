# ====================================================== #
#                     Public API                         #
# ====================================================== #

function create_ingress_nginx() {
  ENTER
  kubectl apply -f ./kubernetes/extensions/ingress-nginx/nginx-v1.11.1.yaml
  EXIT
}
