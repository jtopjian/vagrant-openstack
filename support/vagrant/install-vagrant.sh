apt-get install -y ruby-dev build-essential libxslt-dev libxml2-dev
wget --quiet https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb
dpkg -i vagrant*.deb
rm vagrant*.deb
vagrant plugin install vagrant-openstack-plugin
vagrant box add dummy https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box
vagrant plugin install vagrant-hostmanager
