#!/bin/bash

#synchronize time
apt-get update
apt-get install --fix-missing -y ntpdate
ntpdate -u pool.ntp.org && hwclock -w

#install docker
apt-get update
apt-get install --fix-missing -y ca-certificates curl gnupg2 software-properties-common apt-transport-https hostname
curl -fsSLk https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

#install docker compose
curl -Lk https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#set permissions
groupadd docker && usermod -aG docker root

#set hostname
HOST_NM=$(cat /sys/class/net/eth0/address  | tr -d :)
hostname $HOST_NM
printf "\
  127.0.0.1   localhost $HOST_NM \n \
  " > /etc/hosts

printf "\
  $HOST_NM \n \
  " > /etc/hostname
  
#set inet  
printf "\
    auto lo eth0 \n \
    allow-hotplug eth0 \n \
    iface eth0 inet dhcp \n \
    " > /etc/network/interfaces
printf "\
    nameserver 8.8.8.8 \n \
    nameserver 8.8.4.4 \n \
    " > /etc/resolv.conf

sed -i 's/PermitRootLogin/#PermitRootLogin/' /etc/ssh/sshd_config
echo PermitRootLogin yes >> /etc/ssh/sshd_config

#disable networkmanager
systemctl disable NetworkManager.service
reboot
