#!/bin/bash

cd /root

export OS_SERVICE_TOKEN=password
export OS_SERVICE_ENDPOINT=http://localhost:35357/v2.0
keystone user-create --name admin --pass password
keystone tenant-create --name admin
keystone role-create --name _member_
keystone role-create --name admin
keystone role-create --name ResellerAdmin
keystone user-role-add --user admin --tenant admin --role admin
keystone tenant-create --name services
keystone user-create --name nova --pass password
keystone user-role-add --user nova --tenant services --role admin
keystone user-create --name glance --pass password
keystone user-role-add --user glance --tenant services --role admin
keystone user-create --name cinder --pass password
keystone user-role-add --user cinder --tenant services --role admin
keystone user-create --name swift --pass password
keystone user-role-add --user swift --tenant services --role admin
keystone user-create --name neutron --pass password
keystone user-role-add --user neutron --tenant services --role admin
keystone user-create --name heat --pass password
keystone user-role-add --user heat --tenant services --role admin
keystone user-create --name trove --pass password
keystone user-role-add --user trove --tenant services --role admin

source /root/openrc

wget http://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img
glance image-create --name CirrOS --disk-format qcow2 --container-format bare --is-public true < cirros-*

dd if=/dev/zero of=/cinder-volumes.img bs=1M count=0 seek=10240
losetup /dev/loop0 /cinder-volumes.img
pvcreate /dev/loop0
vgcreate cinder-volumes /dev/loop0

brctl addbr br-int
brctl addbr br-ex

# Get the services UUID to replace it with something standard
SERVICES_UUID=$(keystone tenant-list | grep services | awk '{print $2}')
mysqldump --opt --all-databases --events > cloud.sql
sed -i -e "s/${SERVICES_UUID}/deadbeefc0ffeedeadbeefc0ffee0001/g" cloud.sql
mysql < cloud.sql

for i in /etc/init/glance-*; do basename $i | service $(sed -e 's/.conf//g') restart; done
for i in /etc/init/nova-*; do basename $i | service $(sed -e 's/.conf//g') restart; done
for i in /etc/init/cinder-*; do basename $i | service $(sed -e 's/.conf//g') restart; done
for i in /etc/init/neutron-*; do basename $i | service $(sed -e 's/.conf//g') restart; done
for i in /etc/init/heat-*; do basename $i | service $(sed -e 's/.conf//g') restart; done

sleep 10

neutron net-create --shared default
neutron subnet-create default --name default --allocation-pool start=192.168.1.100,end=192.168.1.200 192.168.1.0/24
neutron router-create default
neutron router-interface-add default default

nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0

apt-get purge -y openstack-dashboard-ubuntu-theme
