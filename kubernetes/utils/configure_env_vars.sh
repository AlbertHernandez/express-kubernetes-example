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

function _configure_values() {
  ENTER
  local app=$1
  local env=$2
  kubectl apply -f ./kubernetes/apps/$app/conf/values.yaml -n $env
  EXIT
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

function _restart_to_apply_new_env_vars() {
  ENTER
  local app=$1
  local env=$2
  kubectl rollout restart deployment $app -n $env
  EXIT
}


# ====================================================== #
#                     Public API                         #
# ====================================================== #

function configure_env_vars() {
  ENTER
  local app=$1
  local env=$2
  _configure_values $app $env
  _configure_secrets $app $env
  _restart_to_apply_new_env_vars $app $env
  EXIT
}
