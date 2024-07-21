source "./kubernetes/utils/logger.sh"

# ====================================================== #
#                  Private Methods                       #
# ====================================================== #

function _delete_metallb_pool() {
  ENTER
  if kubectl get IPAddressPool first-pool -n metallb-system > /dev/null 2>&1; then
    INFO "📝 Deleting IPAddressPool 'first-pool' in namespace 'metallb-system'."
    kubectl delete IPAddressPool first-pool -n metallb-system
  else
    INFO "ℹ️ IPAddressPool 'first-pool' does not exist in namespace 'metallb-system'."
  fi
  EXIT
}

function _delete_metallb_l2_advertisement() {
  if kubectl get L2Advertisement homelab-l2 -n metallb-system > /dev/null 2>&1; then
    INFO "📝 Deleting L2Advertisement 'homelab-l2' in namespace 'metallb-system'."
    kubectl delete L2Advertisement homelab-l2 -n metallb-system
  else
    INFO "ℹ️ L2Advertisement 'homelab-l2' does not exist in namespace 'metallb-system'."
  fi
}

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function delete_metallb_resources() {
  ENTER
  _delete_metallb_pool
  _delete_metallb_l2_advertisement
  kubectl delete all --all -n metallb-system
  EXIT
}

function create_metallb_resources() {
  ENTER
  kubectl apply -f ./kubernetes/extensions/metallb/metallb-v0.14.7.yaml
  kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io metallb-webhook-configuration
  kubectl apply -f ./kubernetes/extensions/metallb/pool.yaml
  kubectl apply -f ./kubernetes/extensions/metallb/l2advertisement.yaml
  EXIT
}
