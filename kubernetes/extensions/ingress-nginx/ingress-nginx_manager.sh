# ====================================================== #
#                     Public API                         #
# ====================================================== #

function create_ingress_nginx() {
  ENTER
  kubectl apply -f ./kubernetes/extensions/ingress-nginx/nginx-v1.11.1.yaml
  kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
  EXIT
}

function delete_ingress_nginx() {
  ENTER
  kubectl delete all --all -n ingress-nginx
  kubectl delete configmaps --all -n ingress-nginx
  EXIT
}
