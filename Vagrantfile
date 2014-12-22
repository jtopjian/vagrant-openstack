VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "dummy"

  # Get homedir
  homedir = File.expand_path('~')

  # SSH
  config.ssh.private_key_path = "#{homedir}/.ssh/id_rsa"

  # Basic OpenStack options
  # Note that an openrc file needs sourced before using
  config.vm.provider :openstack do |os|
    os.username        = ENV['OS_USERNAME']
    os.api_key         = ENV['OS_PASSWORD']
    os.tenant          = ENV['OS_TENANT_NAME']
    os.flavor          = 'm1.small'
    os.image           = 'Ubuntu 14.04'
    os.endpoint        = "#{ENV['OS_AUTH_URL']}/tokens"
    os.keypair_name    = "launchpad"
    os.ssh_username    = "ubuntu"
    os.security_groups = ['default', 'openstack']
    os.network         = 'cybera'
    os.networks        = []
    #os.address_id      = 'cybera'
  end

  # Vagrant Hostmanager
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false

  config.vm.define 'launchpad' do |vm|
    vm.vm.hostname = 'launchpad.example.com'
    vm.vm.provision 'shell', inline: "echo launchpad > /etc/hostname; hostname -F /etc/hostname"
    vm.vm.provision 'shell', path: 'bootstraps/common.sh'
    vm.vm.provision 'shell', inline: "echo role=launchpad > /etc/facter/facts.d/role.txt"
    vm.vm.provision 'shell', path: 'bootstraps/launchpad.sh'
  end

  config.vm.define 'puppet' do |vm|
    vm.vm.hostname = 'puppet.example.com'
    vm.hostmanager.aliases = ['puppet']
    vm.vm.provision 'shell', inline: "echo puppet > /etc/hostname; hostname -F /etc/hostname"
    vm.vm.provision 'shell', path: 'bootstraps/common.sh'
    vm.vm.provision 'shell', inline: "echo role=puppet_master > /etc/facter/facts.d/role.txt"
    vm.vm.provision 'shell', path: 'bootstraps/puppet.sh'
  end

  config.vm.define 'st2' do |vm|
    vm.vm.hostname = 'st2.example.com'
    vm.hostmanager.aliases = ['st2']
    vm.vm.provision 'shell', inline: 'echo st2 > /etc/hostname; hostname -F /etc/hostname'
    vm.vm.provision 'shell', path: 'bootstraps/common.sh'
    vm.vm.provision 'shell', inline: "echo role=stackstorm > /etc/facter/facts.d/role.txt"
    vm.vm.provision 'shell', path: 'bootstraps/run_puppet.sh'
    vm.vm.provision 'shell', path: 'bootstraps/st2.sh'
  end

  config.vm.define 'cloud' do |vm|
    vm.vm.hostname = 'cloud.example.com'
    vm.hostmanager.aliases = ['cloud']
    vm.vm.provision 'shell', inline: "echo cloud > /etc/hostname; hostname -F /etc/hostname"
    vm.vm.provision 'shell', path: 'bootstraps/common.sh'
    vm.vm.provision 'shell', inline: "echo role=cloud_controller > /etc/facter/facts.d/role.txt"
    vm.vm.provision 'shell', path: 'bootstraps/run_puppet.sh'
  end

  config.vm.define 'c01' do |vm|
    vm.vm.hostname = 'c01.example.com'
    vm.hostmanager.aliases = ['c01']
    vm.vm.provider :openstack do |os|
      os.flavor = 'm1.medium'
    end
    vm.vm.provision 'shell', inline: "echo c01 > /etc/hostname; hostname -F /etc/hostname"
    vm.vm.provision 'shell', path: 'bootstraps/common.sh'
    vm.vm.provision 'shell', inline: "echo role=compute_node > /etc/facter/facts.d/role.txt"
    vm.vm.provision 'shell', path: 'bootstraps/run_puppet.sh'
  end

  config.vm.define 'c02' do |vm|
    vm.vm.hostname = 'c02.example.com'
    vm.hostmanager.aliases = ['c02']
    vm.vm.provider :openstack do |os|
      os.flavor = 'm1.medium'
    end
    vm.vm.provision 'shell', inline: "echo c02 > /etc/hostname; hostname -F /etc/hostname"
    vm.vm.provision 'shell', path: 'bootstraps/common.sh'
    vm.vm.provision 'shell', inline: "echo role=compute_node > /etc/facter/facts.d/role.txt"
    vm.vm.provision 'shell', path: 'bootstraps/run_puppet.sh'
  end

  config.vm.define 'stacktach' do |vm|
    vm.vm.hostname = 'stacktach.example.com'
    vm.hostmanager.aliases = ['stacktach']
    vm.vm.provider :openstack do |os|
      os.flavor = 'm1.small'
    end
    vm.vm.provision 'shell', inline: "echo stacktach > /etc/hostname; hostname -F /etc/hostname"
    vm.vm.provision 'shell', path: 'bootstraps/common.sh'
    vm.vm.provision 'shell', inline: "echo role=stacktach > /etc/facter/facts.d/role.txt"
    vm.vm.provision 'shell', path: 'bootstraps/run_puppet.sh'
  end

end
