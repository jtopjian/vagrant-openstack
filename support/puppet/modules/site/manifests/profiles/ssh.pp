class site::profiles::ssh {

  $allow_root_access = hiera_array('ssh::allow_root_access', [])

  sshkeys::create_key { 'root':
    home        => '/root',
    ssh_keytype => 'rsa',
  }

  $allow_root_access.each |$server| {
    sshkeys::set_authorized_key { "root@${server} to root@${::fqdn}":
      local_user => 'root',
      remote_user => "root@${server}",
      home      => '/root',
    }
  }

}
