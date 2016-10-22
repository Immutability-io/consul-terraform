#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT dnsmasq.sh: 0.0.0.0"
}

logger "Executing"

DNSLISTENADDR=0.0.0.0

logger "Installing Dnsmasq"
apt-get -qqy update
apt-get -qqy upgrade
apt-get -qqy install dnsmasq-base dnsmasq

logger "Configuring Dnsmasq"
cat <<EOF >/etc/dnsmasq.d/consul
server=/consul/127.0.0.1#8600
listen-address=$DNSLISTENADDR
bind-interfaces
EOF

cat /etc/dnsmasq.d/consul

logger "Restarting dnsmasq"
service dnsmasq start || service dnsmasq restart

logger "Completed"
