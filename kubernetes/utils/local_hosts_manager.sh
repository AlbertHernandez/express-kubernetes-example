source "./kubernetes/utils/logger.sh"

ENTRY="127.0.0.1 my-company.local"
HOSTS_FILE="/etc/hosts"

############################################
#           Public functions               #
############################################

function add_company_entry_to_hosts_file() {
  ENTER

  if ! grep -q "$ENTRY" "$HOSTS_FILE"; then
    INFO "📝 Adding entry '$ENTRY' to $HOSTS_FILE"

    echo "$ENTRY" | sudo tee -a "$HOSTS_FILE" > /dev/null

    if [ $? -eq 0 ]; then
      INFO "✅ Successfully added entry to $HOSTS_FILE"
    else
      ERROR "❌ Error adding entry to $HOSTS_FILE"
    fi
  else
    INFO "ℹ️ Entry '$ENTRY' already exists in $HOSTS_FILE"
  fi

  EXIT
}


function remove_company_entry_from_hosts_file() {
  ENTER

  if grep -q "$ENTRY" "$HOSTS_FILE"; then
    INFO "📝 Removing entry '$ENTRY' from $HOSTS_FILE"

    sudo sed -i.bak "/$ENTRY/d" "$HOSTS_FILE"

    if [ $? -eq 0 ]; then
      INFO "✅ Successfully removed entry from $HOSTS_FILE"
    else
      ERROR "❌ Error removing entry from $HOSTS_FILE"
    fi
  else
    INFO "ℹ️ Entry '$ENTRY' does not exist in $HOSTS_FILE"
  fi

  EXIT
}
