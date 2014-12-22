#!/bin/bash
echo " ===> Running Puppet"
FQDN=$(facter fqdn)
if [ "${HOSTNAME}" != "puppet" ]; then
  ssh root@puppet.example.com "puppet cert clean ${FQDN}"
  ssh root@puppet.example.com "puppet node deactivate ${FQDN}"
  puppet agent -t
  ssh root@puppet.example.com "puppet cert sign ${FQDN}"
  puppet agent -t
  puppet agent -t
fi

exit 0
