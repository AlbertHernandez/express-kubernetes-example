#!/bin/bash

# Description: This script is used to update the pods with the new image id.
# Usage: update_pods_image_label <app> <env> <image_name>

function update_pods_image_label() {
  ENTER
  local app=$1
  local env=$2
  local image_name=$3
  local image_id=$(echo "$image_name" | cut -d':' -f2)

  INFO "📝 Updating kubernetes pods with the image id $image_id"
  local pods=$(kubectl get pods -n $env -l app.kubernetes.io/name=$app_name -o name)
  for pod in $pods; do
    DEBUG "📝 Adding label to pod $pod"
    kubectl label $pod image=$image_id -n $env --overwrite
  done
  EXIT
}
