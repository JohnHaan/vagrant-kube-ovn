#!/usr/bin/env bash

### apt update
apt -y update
apt -y upgrade

### Permit Root Login
echo -e "vagrant\nvagrant" | passwd root
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
systemctl restart sshd

### hosts file update
echo "192.168.1.101 ovn-cluster-1" >> /etc/hosts
echo "192.168.1.102 ovn-cluster-2" >> /etc/hosts
echo "192.168.1.103 ovn-cluster-3" >> /etc/hosts

### install ovn packages
apt -y install ovn-common ovn-central
systemctl stop ovn-northd
rm -rf /var/lib/ovn/ovn*
rm -rf /var/lib/ovn/.ovn*
