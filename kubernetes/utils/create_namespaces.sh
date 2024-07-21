source "./kubernetes/utils/logger.sh"

# ====================================================== #
#                     Public API                         #
# ====================================================== #

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
