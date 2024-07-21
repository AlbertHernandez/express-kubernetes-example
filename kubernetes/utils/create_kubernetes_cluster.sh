source "./logger.sh"
source "./build_docker_image.sh"
source "./update_version_label_in_kubernetes_deployment.sh"
source "./local_hosts_manager.sh"

function create_namespaces() {
  ENTER

  local namespace="development"

  if kubectl get namespace "$namespace" > /dev/null 2>&1; then
    INFO "ℹ️ Namespace '$namespace' already exists."
  else
    INFO "📝 Creating namespace '$namespace'."
    kubectl create namespace "$namespace"

    if [ $? -eq 0 ]; then
      INFO "✅ Successfully created namespace '$namespace'."
    else
      ERROR "❌ Error creating namespace '$namespace'."
    fi
  fi

  EXIT
}

function configure_hpa_tools() {
  ENTER
  kubectl apply -f ./metrics-server/component-v0.7.1.yaml
  EXIT
}

function create_express_kubernetes_example_resources() {
  ENTER
  build_docker_image "express-kubernetes-example" "development"
  kubectl apply -f ../apps/express-kubernetes-example/deployment.yaml -n development
  update_version_label_in_kubernetes_deployment "express-kubernetes-example" "development"
  kubectl apply -f ../apps/express-kubernetes-example/service.yaml -n development
  kubectl apply -f ../apps/express-kubernetes-example/hpa.yaml -n development
  kubectl apply -f ../apps/express-kubernetes-example/ingress.yaml -n development
  EXIT
}

function create_api_gateway() {
  ENTER
  kubectl apply -f ../cluster/api-gateway/ingress-nginx/nginx-v1.11.1.yaml -n development
  EXIT
}

function main() {
  ENTER
  create_namespaces
  configure_hpa_tools
  create_express_kubernetes_example_resources
  create_api_gateway
  add_company_entry_to_hosts_file
  EXIT
}

main
