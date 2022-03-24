#!/bin/bash

cat >/etc/sysconfig/network-scripts/ifcfg-eth0 <<EOT
NAME="eth0"
DEVICE="eth0"
ONBOOT=yes
NETBOOT=yes
IPV6INIT=no
BOOTPROTO=dhcp
TYPE=Ethernet
EOT
