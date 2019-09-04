#!/usr/bin/env bash

# create dir for nomad configuration
sudo mkdir -p /etc/nomad.d
sudo chmod 700 /etc/nomad.d

# download and run nomad configuration script
curl -o /tmp/nomad-${instance_role}-config.sh https://raw.githubusercontent.com/achuchulev/terraform-aws-nomad_instance/master/scripts/nomad-${instance_role}-config.sh
chmod +x /tmp/nomad-${instance_role}-config.sh
sudo /tmp/nomad-${instance_role}-config.sh ${nomad_region} ${dc} ${authoritative_region} '${retry_join}' ${secure_gossip}
rm -rf /tmp/*

# create dir for certificates and copy cfssl.json configuration file to increase the default certificate expiration time for nomad
mkdir -p ~/nomad/ssl
curl -o ~/nomad/ssl/cfssl.json https://github.com/achuchulev/terraform-aws-nomad_instance/blob/master/config/cfssl.json

# download CA certificates
curl -o ~/nomad/ssl/nomad-ca-key.pem https://raw.githubusercontent.com/achuchulev/terraform-aws-nomad_instance/master/ca_certs/nomad-ca-key.pem
curl -o ~/nomad/ssl/nomad-ca.csr https://raw.githubusercontent.com/achuchulev/terraform-aws-nomad_instance/master/ca_certs/nomad-ca.csr
curl -o ~/nomad/ssl/nomad-ca.pem https://raw.githubusercontent.com/achuchulev/terraform-aws-nomad_instance/master/ca_certs/nomad-ca.pem
 
# generate nomad node certificates
sudo echo '{}' | cfssl gencert -ca=nomad/ssl/nomad-ca.pem -ca-key=nomad/ssl/nomad-ca-key.pem -config=/tmp/cfssl.json -hostname='${instance_role}.${nomad_region}.nomad,localhost,127.0.0.1' - | cfssljson -bare nomad/ssl/${instance_role}

# copy nomad.service
sudo curl -o /etc/systemd/system/nomad.service https://raw.githubusercontent.com/achuchulev/terraform-aws-nomad_instance/master/config/nomad.service
sudo echo '{}' | cfssl gencert -ca=nomad/ssl/nomad-ca.pem -ca-key=nomad/ssl/nomad-ca-key.pem -profile=client - | cfssljson -bare nomad/ssl/cli

# enable and start nomad service
sudo systemctl enable nomad.service
sudo systemctl start nomad.service

# Enable Nomad's CLI command autocomplete support. Skip if installed
grep "complete -C /usr/bin/nomad nomad" ~/.bashrc &>/dev/null || nomad -autocomplete-install

# export the URL of the Nomad agent
echo 'export NOMAD_ADDR=https://${domain_name}.${zone_name}' >> ~/.profile
