#!/bin/bash

# Usage: ./deploy_app.sh --app=<app_name> --env=<env>
# Example: ./deploy_app.sh --app="express-kubernetes-example" --env="development"

source "./logger.sh"
source "./get_image_name.sh"
source "./build_docker_image.sh"
source "./update_version_label_in_kubernetes_deployment.sh"

function log_help() {
  INFO "🚁 Usage: ./deploy_app.sh --app=<app_name> --env=<env>"
  INFO '💡 Example: ./deploy_app.sh --app="express-kubernetes-example" --env="development"'
}

function validate_app_name() {
  ENTER
  if [ -z "$app_name" ]; then
    ERROR "❌ Error: No application name provided."
    log_help
    exit 1
  fi
  EXIT
}

function validate_environment() {
  VALID_ENVS=("development")
  ENTER
  if [ -z "$env" ]; then
    ERROR "❌ Error: No env provided."
    log_help
    exit 1
  fi

  local valid=false
  for valid_environments in "${VALID_ENVS[@]}"; do
    if [ "$env" == "$valid_environments" ]; then
      valid=true
      break
    fi
  done

  if [ "$valid" == false ]; then
    ERROR "❌ Error: Invalid '$env' env. Must be one of: ${VALID_ENVS[*]}."
    log_help
    exit 1
  fi
  EXIT
}

function parse_arguments() {
  ENTER
  for arg in "$@"; do
    case $arg in
      --app=*)
        app_name="${arg#*=}"
        shift
        ;;
      --env=*)
        env="${arg#*=}"
        shift
        ;;
      *)
        ERROR "❌ Error: Invalid argument '$arg'"
        log_help
        exit 1
        ;;
    esac
  done
  EXIT
}

function check_arguments() {
  ENTER
  validate_app_name
  validate_environment
  EXIT
}

function label_kubernetes_deployment() {
  ENTER
  local image_name=$1
  local image_tag=$(echo $image_name | cut -d':' -f2)
  DEBUG "📝 Adding label 'image=$image_tag' to kubernetes deployment $app_name"
  kubectl label deployment/$app_name version=$image_tag -n $env --overwrite
  EXIT
}

function main() {
  ENTER
  parse_arguments "$@"
  check_arguments
  INFO "🚀 Deploying the app $app_name to $env"
  build_docker_image $app_name $env
  update_version_label_in_kubernetes_deployment $app_name $env
  INFO "🎉 Successfully deployed!"
  EXIT
}

main "$@"
