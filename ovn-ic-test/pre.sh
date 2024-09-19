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
echo "192.168.1.111 ovn-aio-1" >> /etc/hosts
echo "192.168.1.112 ovn-aio-2" >> /etc/hosts

### install ovn packages
apt -y install ovn-common ovn-central
systemctl restart ovn-central

sleep 10
ovn-nbctl set-connection ptcp:6641:0.0.0.0 -- set connection . inactivity_probe=60000
ovn-sbctl set-connection ptcp:6642:0.0.0.0 -- set connection . inactivity_probe=60000