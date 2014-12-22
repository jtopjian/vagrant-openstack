#!/bin/bash

echo " ===> Installing required development packages"
apt-get update
apt-get install -y git debhelper cdbs python-setuptools python-support

echo " ===> Building a Debian package from StackTach repo"
cd /root
git clone https://github.com/rackerlabs/stacktach
cd stacktach
dpkg-buildpackage

echo " ===> Installing StackTach"
dpkg -i /root/*.deb
apt-get install -fy

echo " ===> Doing some basic post-install configuration"
chown -R stacktach: /etc/stacktach
chown -R stacktach: /usr/share/stacktach
cd /etc/stacktack
cp sample_local_settings.py local_settings.py
