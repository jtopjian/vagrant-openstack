class site::roles::puppet_master {
  contain site::profiles::base
  contain apache
  contain apache::mod::ssl
  contain apache::mod::passenger
  contain puppet::master
  contain puppetdb
  contain puppetdb::master::config
}
