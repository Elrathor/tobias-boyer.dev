cd infrastructure/open-tofu

ansible-playbook -i "$(tofu -chdir=../open-tofu output -raw server_ipv4)," \
  -u root \
  ../ansible/server-init.yml