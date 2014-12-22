#!/bin/bash

echo " ===> Configuring SSH"
if [ ! -f /vagrant/support/keys/id_rsa ]; then
  mkdir -p /vagrant/support/keys
  /usr/bin/ssh-keygen -t rsa -f /vagrant/support/keys/id_rsa -N '' -C 'shared'
  chmod 0600 /vagrant/support/keys/id_rsa.pub
fi
mkdir -p /root/.ssh
cp /vagrant/support/keys/* /root/.ssh/
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
chmod -R 0600 /root/.ssh

echo " ===> Configuring main Puppet manifest"
sed -i '/\[main\]/a manifest=/etc/puppet/modules/site/manifests/site.pp' /etc/puppet/puppet.conf

echo " ===> Installing Librarian Puppet Simple"
gem install librarian-puppet-simple

echo " ===> Installing Modules"
cd /etc/puppet/
librarian-puppet install --puppetfile=/vagrant/support/puppet/Puppetfile

echo " ===> Configuring Hiera"
rm /etc/hiera.yaml
ln -s /etc/puppet/modules/site/ext/hiera.yaml /etc
ln -s /etc/puppet/modules/site/ext/hiera.yaml /etc/puppet
gem install deep_merge

echo " ===> Checking if SSL cert exists."
echo " ===> and generating one if it doesnt."
if [ ! -e "$(puppet config print hostcert)" ]; then
  puppet cert generate $(puppet config print certname)
fi

echo " ===> Installing PuppetDB"
apt-get -y install puppetdb
cd /root
echo include puppetdb > pdb.pp
echo include puppetdb::master::config >> pdb.pp
puppet apply --verbose pdb.pp
rm pdb.pp

echo " ===> Installing Puppet Master Role"
puppet apply --verbose /etc/puppet/modules/site/manifests/site.pp
rm -rf /var/lib/puppet/l2mesh
puppet agent -t
