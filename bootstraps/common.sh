#!/bin/bash

# Make sure this is correct!
PUPPET_IP=10.1.0.254

HOSTNAME=$(hostname)

cd /root

echo " ===> Setting acng server"
echo "Acquire::http { Proxy \"http://acng-yyc.cloud.cybera.ca:3142\"; };"  > /etc/apt/apt.conf.d/01-acng

echo " ===> Setting a hostname"
#sed -i -e "s/127.0.1.1.*/127.0.1.1 ${HOSTNAME}.example.com ${HOSTNAME}/" /etc/hosts
sed -i "2i127.0.1.1 ${HOSTNAME}.example.com ${HOSTNAME}" /etc/hosts

echo " ===> Installing base packages"
apt-get update
apt-get install -y curl wget git ruby tinc

echo " ===> Installing the Puppetlabs apt repo"
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
rm puppetlabs-release-trusty.deb
apt-get update

echo "Installing Puppet"
apt-get install -y puppet=3.6.2-1puppetlabs1 puppet-common=3.6.2-1puppetlabs1

echo "Configure Puppet"
sed -i '/templatedir/d' /etc/puppet/puppet.conf
puppet config set --section main parser future
puppet config set --section main evaluator current
puppet config set --section main ordering manifest

echo "Setting up dotfiles"
git clone https://github.com/jtopjian/dotfiles /root/.dotfiles
cd /root/.dotfiles
bash create.sh

mkdir -p /etc/facter/facts.d

echo " ===> Installing Sandbox SSH keys"
if [ ${HOSTNAME} != "puppet" ]; then
  mkdir -p /root/.ssh
  cp /vagrant/support/keys/* /root/.ssh
  cp /vagrant/support/keys/id_rsa.pub /root/.ssh/authorized_keys
  chown -R root: /root/.ssh
  chmod -R 0400 /root/.ssh/id_rsa
fi

echo " ===> Configuring SSH"
cat > /root/.ssh/config <<EOF
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
EOF

exit 0
