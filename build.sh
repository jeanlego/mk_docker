#!/bin/bash
# apt-get update && apt-get upgrade -y
# apt-get install --fix-missing -y ca-certificates curl gnupg2 ntpdate software-properties-common ntpdate apt-transport-https hostname

# #synchronize time
# ntpdate -u pool.ntp.org && hwclock -w

#set hostname
HOST_NM=$(cat /sys/class/net/eth0/address  | tr -d :)
printf "\
  127.0.0.1   localhost $HOST_NM \n\
  ::1         localhost $HOST_NM ip6-localhost ip6-loopback \n\
  fe00::0     ip6-localnet \n\
  ff00::0     ip6-mcastprefix \n\
  ff02::1     ip6-allnodes \n\
  ff02::2     ip6-allrouters \n\
  " > /etc/hosts

printf "\
  $HOST_NM \
  " > /etc/hosts
  
hostname ${HOST_NM}
systemctl hostname restart

# #install docker
# curl -fsSLk https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# apt-key fingerprint 0EBFCD88
# add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# apt-get update
# apt-get install -y docker-ce

# #install docker compose
# curl -Lk https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose
# groupadd docker

# usermod -aG docker root
# usermod -aG docker admin
reboot
