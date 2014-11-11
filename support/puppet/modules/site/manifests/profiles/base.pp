class site::profiles::base {
  contain puppet
  contain puppet::agent
  contain site::profiles::ssh
  contain l2mesh
  contain l2mesh::l3
}
