#!/bin/bash

# Fetches a secret from Vault
getSecret() {
  path="$1"
  vault kv get --format=json $path | jq '.data.data'
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
