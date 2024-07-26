source "./kubernetes/utils/logger.sh"

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function configure_env_vars() {
    ENTER
    kubectl apply -f ./kubernetes/apps/express-kubernetes-example/conf/values.yaml -n development
    kubectl rollout restart deployment express-kubernetes-example -n development # Force the restart of the deployment to use the new environment variables
    EXIT
}
