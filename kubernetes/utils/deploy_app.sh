#!/bin/bash

# Usage: ./deploy_app.sh --app=<app_name> --env=<env>
# Example: ./deploy_app.sh --app="express-kubernetes-example" --env="development"

source "../utils/logger.sh"

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

function get_image_name() {
  local commit_hash=$(git rev-parse --short HEAD)
  local image_name="$app_name:$commit_hash"
  echo "$image_name"
}

function build_docker_image() {
  ENTER
  local image_name=$1
  INFO "🐳 Building docker image $image_name"
  docker build -t $image_name -t $app_name:$env -f ../../Dockerfile ../../
  EXIT
}

function update_kubernetes_deployment() {
  ENTER
  local image_name=$1
  INFO "💃 Updating kubernetes deployment with the new image $image_name"
  kubectl set image deployment/$app_name $app_name=$image_name -n $env
  EXIT
}

function update_pods_image_label() {
  ENTER
  local image_name=$1
  local image_id=$(echo "$image_name" | cut -d':' -f2)
  INFO "🤗 Updating kubernetes deployment with the new image id $image_id"
  local pods=$(kubectl get pods -n $env -l app.kubernetes.io/name=$app_name -o name)
  for pod in $pods; do
    DEBUG "📝 Adding label to pod $pod"
    kubectl label $pod image=$image_id -n $env --overwrite
  done
  EXIT
}

function main() {
  ENTER
  parse_arguments "$@"
  check_arguments
  INFO "🚀 Deploying the app $app_name to $env"
  local image_name=$(get_image_name)
  build_docker_image $image_name
  update_kubernetes_deployment $image_name
  update_pods_image_label $image_name
  EXIT
}

main "$@"
