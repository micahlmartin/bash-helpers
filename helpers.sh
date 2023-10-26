#!/bin/bash

# Tracks a list of variables that need to be exported to the .env file
export exported_variables=()
setVar() {
    key=$1
    val=$2
    export "$key"="$val"
    exported_variables+=("$key")
}

# export all of the variables in the array to the .env file
writeEnv() {
  # Iterate over the variable names in the array
  for var in "${exported_variables[@]}"; do
      # Get the value of the variable
      value="${!var}"
      # Write the variable assignment to the .env file
      echo "export $var=\"$value\"" >> "$env_file"
  done
}

# Define a Bash function to get the Docker registry based on deployment stage
getDockerRegistry() {
    local deploymentStage="${1:-production}"
    local registryConfig
    registryConfig=$(getNexusDockerRegistryConfig)
    echo "$registryConfig" | jq -r ".$deploymentStage"
}

# Define a Bash function to get Nexus Docker registry config in JSON format
getNexusDockerRegistryConfig() {
    cat <<EOF
{
  "development": "development.url.here",
  "staging": "staging.url.here",
  "production": "production.url.here"
}
EOF
}

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
