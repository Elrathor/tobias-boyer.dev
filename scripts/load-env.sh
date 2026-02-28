#!/usr/bin/env bash
# Tiny helper script to load environment variables from .env file into the current shell session
# useful for local development with open tofu
# Usage: source ./scripts/load-env.sh (or: . ./scripts/load-env.sh)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

if [[ -f "$ENV_FILE" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        if [[ "$line" =~ ^[[:space:]]*([^#][^=]+?)[[:space:]]*=[[:space:]]*\"?(.*?)\"?[[:space:]]*$ ]]; then
            name="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"

            case "$name" in
                S3_ACCESS_KEY)           export AWS_ACCESS_KEY_ID="$value" ;;
                S3_SECRET_KEY)           export AWS_SECRET_ACCESS_KEY="$value" ;;
                CLOUDFLARE_TOKEN_VALUE)  export CLOUDFLARE_API_TOKEN="$value" ;;
                HETZNER_TOKEN)           export TF_VAR_hcloud_token="$value" ;; # Prefix with TF_VAR_ to make it available as a variable in Terraform
            esac
        fi
    done < "$ENV_FILE"
    echo "Environment variables loaded from .env"
else
    echo "WARNING: .env file not found at $ENV_FILE" >&2
fi
