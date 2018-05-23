#!/bin/bash
apt-get update && apt-get upgrade -y

#set hostname
HOST_NM=$(cat /sys/class/net/eth0/address  | tr -d :)
sed -i 's/pine64so/$HOST_NM/g' /etc/hosts
sed -i 's/pine64so/$HOST_NM/g' /etc/hostname
hostname $HOST_NM
systemctl hostname restart

#install docker
apt-get install --fix-missing --reinstall -y apt-transport-https
apt-get install --fix-missing -y ca-certificates curl gnupg2 ntpdate software-properties-common
     
curl -fsSLk https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

#install docker compose
curl -Lk https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
groupadd docker

usermod -aG docker root
usermod -aG docker admin
