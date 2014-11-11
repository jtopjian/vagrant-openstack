#!/bin/bash

curl -q -k -O https://ops.stackstorm.net/releases/st2/scripts/st2_deploy.sh
bash st2_deploy.sh

sed -i -e 's/user = stanley/user = root/' /etc/st2/st2.conf
sed -i -e 's#ssh_key_file = //home/stanley/.ssh/stanley_rsa#ssh_key_file = /root/.ssh/id_rsa#' /etc/st2/st2.conf

st2ctl restart
