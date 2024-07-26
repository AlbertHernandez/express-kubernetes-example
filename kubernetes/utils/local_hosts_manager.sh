source "./kubernetes/utils/logger.sh"

HOSTS_FILE="/etc/hosts"
DOMAIN_SUFFIX=".local"

############################################
#           Public functions               #
############################################

function add_service_to_hosts_file() {
  local base_name="$1"
  local entry="127.0.0.1 ${base_name}${DOMAIN_SUFFIX}"

  ENTER

  if [ -z "$base_name" ]; then
    ERROR "❌ Base name argument is missing."
    return 1
  fi

  if ! grep -q "$entry" "$HOSTS_FILE"; then
    INFO "📝 Adding entry '$entry' to $HOSTS_FILE"

    echo "$entry" | sudo tee -a "$HOSTS_FILE" > /dev/null

    if [ $? -eq 0 ]; then
      INFO "✅ Successfully added entry to $HOSTS_FILE"
    else
      ERROR "❌ Error adding entry to $HOSTS_FILE"
    fi
  else
    INFO "ℹ️ Entry '$entry' already exists in $HOSTS_FILE"
  fi

  EXIT
}

function remove_service_from_hosts_file() {
  local base_name="$1"
  local entry="127.0.0.1 ${base_name}${DOMAIN_SUFFIX}"

  ENTER

  if [ -z "$base_name" ]; then
    ERROR "❌ Base name argument is missing."
    return 1
  fi

  if grep -q "$entry" "$HOSTS_FILE"; then
    INFO "📝 Removing entry '$entry' from $HOSTS_FILE"

    sudo sed -i.bak "/$entry/d" "$HOSTS_FILE"

    if [ $? -eq 0 ]; then
      INFO "✅ Successfully removed entry from $HOSTS_FILE"
    else
      ERROR "❌ Error removing entry from $HOSTS_FILE"
    fi
  else
    INFO "ℹ️ Entry '$entry' does not exist in $HOSTS_FILE"
  fi

  EXIT
}
