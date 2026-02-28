#!/bin/bash
cd ../infrastructure/ansible

ansible-galaxy install -r requirements.yml

cd ../open-tofu

# Make sure docker is up and running
ansible-playbook -i "$(tofu -chdir=../open-tofu output -raw server_ipv4)," \
  -u root \
  ../ansible/server-init.yml

# Deploy the application containers
ansible-playbook -i "$(tofu -chdir=../open-tofu output -raw server_ipv4)," \
  -u root \
  ../ansible/deploy-container.yml