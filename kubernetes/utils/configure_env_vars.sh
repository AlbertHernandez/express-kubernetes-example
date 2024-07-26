source "./kubernetes/utils/logger.sh"

# ====================================================== #
#                  Private Methods                       #
# ====================================================== #

_convert_yaml_data_to_base64() {
    local yaml_content="$1"
    local base64_content
    base64_content=$(echo "$yaml_content" | yq eval '
        .data |= with_entries(
            .value = (.value | @base64)
        )
    ')
    echo "$base64_content"
}

function _configure_secrets() {
  ENTER
  local app=$1
  local env=$2
  local file="./kubernetes/apps/$app/conf/secrets.yaml"
  local decrypted_file=$(sops decrypt "$file" --output-type yaml)
  local yaml_result=$(_convert_yaml_data_to_base64 "$decrypted_file")
  kubectl apply -f - -n $env <<< "$yaml_result"
  EXIT
}


# ====================================================== #
#                     Public API                         #
# ====================================================== #

function configure_env_vars() {
  ENTER
  local app=$1
  local env=$2
  kubectl apply -f ./kubernetes/apps/$app/conf/values.yaml -n $env
  _configure_secrets $app $env
  kubectl rollout restart deployment $app -n $env # Force the restart of the deployment to use the new environment variables
  EXIT
}
