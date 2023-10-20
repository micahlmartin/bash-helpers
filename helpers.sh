#!/bin/bash

# Fetches a secret from Vault
getSecret() {
  path="$1"

  export VAULT_SKIP_VERIFY=$VAULT_SKIP_VERIFY
  export VAULT_ADDR=$VAULT_ADDR
  export VAULT_TOKEN=$VAULT_TOKEN

  set +x
  vault kv get --format=json $path | jq '.data.data'
}

vaultLogin() {
  role_id="$1"
  secret_id="$2"
  
  export VAULT_ADDR=$VAULT_ADDR
  export VAULT_SKIP_VERIFY=$VAULT_SKIPVERIFY

  vault write --format=json auth/approle/login role_id="${role_id}" secret_id="${secret_id}" | jq -r '.auth.client_token'
}

# Function to log debug messages
log_debug() {
  local message="$1"
  if [ ! -z "$DEBUG" ]; then
      echo "---------> DEBUG: $message"
  fi
}

# Function to log a message
log() {
  local message="---------> INFO: $1"
  echo "$message"
}

# Function to log an error message and exit
fatal() {
  local message="$1"
  >&2 echo "----> Error: $message"
  exit 1
}
