OpenStack Demo
==============

This repsository contains everything needed to deploy a simple OpenStack environment inside OpenStack. This is useful for demo or testing purposes.

Requirements
------------

* Vagrant
* Vagrant OpenStack Plugin
* Vagrant Hostmanager Plugin

Instructions
------------

1. Optionally create a `launchpad` server that acts as a remote server where you can run everything via tmux, etc.

2. Either add an existing SSH keypair to `vagrant/support/keys`, or wait until the Puppet node generates a pair and copy it locally.

3. Deploy the Puppet node:

        vagrant up --provider openstack puppet

4. Deploy the cloud controller:

        vagrant up --provider openstack cloud

5. Run the `openstack-prep.sh` script:

        vagrant ssh cloud
        sudo bash /vagrant/support/openstack/openstack-prep.sh

6. Deploy the compute nodes:

        vagrant up --provider openstack c01
        vagrant up --provider openstack c02

7. Deploy the `st2` instance that runs [StackStorm](http://stackstorm.com/):

        vagrant up --provider openstack st2
