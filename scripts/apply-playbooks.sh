#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../infrastructure/ansible"

ansible-galaxy install -r requirements.yml

TOFU_DIR="$SCRIPT_DIR/../infrastructure/open-tofu"
SERVER_IP="$(tofu -chdir="$TOFU_DIR" output -raw server_ipv4)"

# Make sure docker is up and running
ansible-playbook -i "$SERVER_IP," \
  -u root \
  ../ansible/server-init.yml

# Deploy the application containers
ansible-playbook -i "$SERVER_IP," \
  -u root \
  ../ansible/deploy-container.yml