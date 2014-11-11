node /puppet./ {
  include site::roles::puppet_master
}

node /cloud/ {
  include site::roles::cloud_controller
}

node /c01/ {
  include site::roles::compute_node
}

node /c02/ {
  include site::roles::compute_node
}

node /st2/ {
  include site::profiles::base
}
